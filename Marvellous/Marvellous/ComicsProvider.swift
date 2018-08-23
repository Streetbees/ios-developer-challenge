//
//  ComicsProvider.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-23.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire
import Realm
import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

struct Signer {
    let privateKey: String
    let publicKey: String

    func hash(timestamp: Date) -> String {
        let timestampString = String(timestamp.timeIntervalSinceReferenceDate)
        return (timestampString + privateKey + publicKey).md5()
    }
}

struct ComicsRequest: URLConvertible {
    enum EndPoint: String {
        case comics = "public/comics"

        var version: String {
            switch self {
            case .comics: return "v1"
            }
        }
    }

    private let base = "https://gateway.marvel.com"

    private let endpoint: EndPoint

    // Public

    init(_ endpoint: EndPoint) {
        self.endpoint = endpoint
    }

    func asURL() throws -> URL {
        return URL(string: base)!.appendingPathComponent(endpoint.version).appendingPathComponent(endpoint.rawValue)
    }
}

protocol ComicsProviderType {
    var count: Driver<Int> { get }
    func getComic(_ withOffset: Int) -> Single<Comic>
}

enum ComicError: Error {
    case unavailable
    case couldNotSave
    case noPhoto
    case placeholderPhotoAlreadySaved
    case photoAlreadySaved
    case alreadyRequested
    case alreadyDownloaded
}

private let pageLength = 50
let placeholderPath = "image_not_available.jpg"

class ComicsProvider: ComicsProviderType {
    private let signer: Signer
    private let decoder = JSONDecoder()

    private let realm = try! Realm()
    private let sortedComics: Results<Comic>

    private var alreadyRequested: Set<Int> = []
    private let bag = DisposeBag()

    init(privateKey: String, publicKey: String) {
        self.signer = Signer(privateKey: privateKey, publicKey: publicKey)
        self.sortedComics = realm.objects(Comic.self).sorted(byKeyPath: "offset")
        self.count = Observable.collection(from: sortedComics)
            .map { ($0.last?.offset).flatMap { $0 + 1 } ?? 0 }
            .asDriver(onErrorJustReturn: 0)

        count.asObservable()
            .subscribe()
            .disposed(by: bag)
    }

    // MARK: - Comics Provider Type methods

    let count: Driver<Int>

    func getComic(_ offset: Int) -> Single<Comic> {
        downloadIfNeeded(chunkAt: offset).subscribe(onError: handleError).disposed(by: bag)
        downloadIfNeeded(chunkAt: offset + pageLength).subscribe(onError: handleError).disposed(by: bag)

        return comic(offset: offset)
    }

    // MARK: - Helpers

    private func handleError(error: Error) {
        // ignore for now
    }

    private func comic(offset: Int) -> Single<Comic> {
        let comicResults = sortedComics.filter("offset == %@", offset)
        return Observable.collection(from: comicResults)
            .map { $0.first }
            .filter { $0 != nil }
            .map { $0! }
            .take(1)
            .asSingle()
    }

    private func downloadIfNeeded(chunkAt offset: Int) -> Completable {
        guard realm.object(ofType: Comic.self, forPrimaryKey: offset) == nil else {
            return Completable.error(ComicError.alreadyDownloaded)
        }

        guard !alreadyRequested.contains(offset) else {
            return Completable.error(ComicError.alreadyRequested)
        }

        return download(offset: pageLength*(offset/pageLength), limit: pageLength)
            .retry(3)
            .flatMap(save)
            .flatMapCompletable(downloadThumbnails)
    }

    private func download(offset: Int, limit: Int) -> Single<[Comic]> {
        (offset..<offset + limit).forEach { alreadyRequested.insert($0) }

        let params = parameters(offset: offset, limit: limit)
        return Single.create { event in
            Alamofire.request(ComicsRequest(.comics), parameters: params, headers: nil)
                .responseData { response in
                    switch response.result {
                    case .success(let json):
                        do {
                            let data = try self.decoder.decode(ComicDataWrapper.self, from: json).data
                            for (comic, offset) in zip(data.results, data.downloadedRange) {
                                comic.offset = offset
                            }

                            event(.success(data.results))
                        }
                        catch {
                            event(.error(error))
                        }

                    case .failure(let error):
                        event(.error(error))
                    }
            }

            return Disposables.create { [weak self] in
                (offset..<offset + limit).forEach { self?.alreadyRequested.remove($0) } }
        }
    }

    private func save(comics: [Comic]) -> Single<[Comic]> {
        return Single.create { [unowned self] event in
            do {
                try self.realm.write {
                    self.realm.add(comics, update: true)
                    event(.success(comics))
                }
            }
            catch {
                event(.error(ComicError.couldNotSave))
            }

            return Disposables.create()
        }
    }

    private func downloadThumbnails(comics: [Comic]) -> Completable {
        let tasks = comics.map { self.downloadThumbnail(comic: $0).retry(3) }
        return Completable.merge(tasks)
    }

    private func downloadThumbnail(comic: Comic) -> Completable {
        if comic.thumbnail != nil {
            return .empty()
        }

        guard let path = comic.thumbnailPath else {
            return .empty()
        }

        if path.hasSuffix(placeholderPath) {
            return .empty()
        }

        return Completable.create { [unowned self] event in
            Alamofire
                .request(path)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            try self.realm.write {
                                comic.thumbnail = data
                                event(.completed)
                            }
                        }
                        catch {
                            event(.error(error))
                        }
                    case .failure(let error):
                        event(.error(error))
                    }
            }
            return Disposables.create()
        }
    }

    // Private helper methods

    private func parameters(offset: Int, limit: Int) -> Parameters {
        let timestamp = Date()
        return ["apikey" : signer.publicKey, "ts" : timestamp.timeIntervalSinceReferenceDate, "hash" : signer.hash(timestamp: timestamp), "limit" : limit, "offset" : offset]
    }
}
