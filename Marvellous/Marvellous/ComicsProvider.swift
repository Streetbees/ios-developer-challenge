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
}

private let pageLength = 30

class ComicsProvider: ComicsProviderType {
    private let signer: Signer
    private let decoder = JSONDecoder()

    private let realm = try! Realm()
    private let sortedComics: Results<Comic>

    private var requested: Set<Int> = []
    private let bag = DisposeBag()

    init(privateKey: String, publicKey: String) {
        self.signer = Signer(privateKey: privateKey, publicKey: publicKey)
        self.sortedComics = realm.objects(Comic.self).sorted(byKeyPath: "offset")
        self.count = Observable.collection(from: sortedComics)
            .map { ($0.last?.offset).flatMap { $0 + 1 } ?? 0 }
            .asDriver(onErrorJustReturn: 0)
            .debug(" ================= COUNT")

        count.asObservable()
            .subscribe()
            .disposed(by: bag)

        getComic(0)
            .subscribe()
            .disposed(by: bag)
    }

    // MARK: - Comics Provider Type methods

    let count: Driver<Int>

    func getComic(_ offset: Int) -> Single<Comic> {
        if let comic = realm.object(ofType: Comic.self, forPrimaryKey: offset) {
            print("=== OFFSET \(offset) existed, has thumbnail: \(comic.thumbnail != nil)")
            return .just(comic)
        }
        else if requested.contains(offset) {
            print("=== OFFSET \(offset) has already been requested")

            // No need to request it again, just pass along an observable that will eventually contain the comic
            let comicResults = sortedComics.filter("offset == %@", offset)
            return Observable.collection(from: comicResults)
                .map { $0.first }
                .filter { $0 != nil }
                .map { $0! }
                .take(1)
                .asSingle()
                .do(onSuccess: { print("====== OFFSET \($0.offset) has been received") })
        }

        print("=== OFFSET \(offset) will be requested")

        // Make a new request and return the eventual result in an observable
        let requestedOffset = pageLength*offset/pageLength
        let requestedLimit = 2*pageLength
        return download(offset: requestedOffset, limit: requestedLimit)
            .retry(3)
            .flatMap(save)
            .do(onSuccess: { [unowned self] in self.downloadThumbnails(comics: $0) },
                onError: { _ in (requestedOffset..<requestedOffset + requestedLimit).forEach { self.requested.remove($0) } })
            .flatMap { comics in
                if let comic = comics.first(where: { $0.offset == offset }) {
                    return Single.just(comic)
                }
                else {
                    return Single.error(ComicError.unavailable)
                }
        }
    }

    // MARK: - Helpers

    private func download(offset: Int, limit: Int) -> Single<[Comic]> {
        // Add offsets to list of requested items
        (offset..<offset + limit).forEach { requested.insert($0) }

        let params = parameters(offset: offset, limit: limit)
        return Single.create { event in
            print("Trying to download comics: \(offset)..<\(offset + limit)")
            Alamofire.request(ComicsRequest(.comics), parameters: params, headers: nil)
                .responseData { response in
                    switch response.result {
                    case .success(let json):
                        do {
                            let data = try self.decoder.decode(ComicDataWrapper.self, from: json).data
                            for (comic, offset) in zip(data.results, data.downloadedRange) {
                                comic.offset = offset
                            }

                            print("Downloaded comics: \(offset)..<\(offset + limit)")
                            event(.success(data.results))
                        }
                        catch {
                            print("Parse failed: \(error)")
                            event(.error(error))
                        }

                    case .failure(let error):
                        print("Download failed: \(error)")
                        event(.error(error))
                    }
            }

            return Disposables.create()
        }
    }

    private func save(comics: [Comic]) -> Single<[Comic]> {
        do {
            try realm.write {
                self.realm.add(comics, update: true)
            }

            // Remove offsets for received comics from list of requested items
            comics.forEach { requested.remove($0.offset) }
            return .just(comics)
        }
        catch {
            return .error(ComicError.couldNotSave)
        }
    }

    private func downloadThumbnails(comics: [Comic]) {
//        for comic in comics {
//            downloadThumbnail(comic: comic)
//                .retry(3)
//                .subscribe()
//                .disposed(by: bag)
//        }
    }

    private func downloadThumbnail(comic: Comic) -> Completable {
        guard let path = comic.thumbnailPath else {
            return .error(ComicError.noPhoto)
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
                            }
                            print("Downloaded image: \(comic.offset)")
                            event(.completed)
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
