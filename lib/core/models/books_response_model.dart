import 'package:flutter/material.dart';

class BooksResponseModel {
  BooksResponseModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });
  late final int count;
  late final String next;
  late final String previous;
  late final List<Results> results;

  BooksResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 0;
    next = json['next'] ?? '';
    previous = json['previous'] ?? '';
    results =
        List.from(json['results']).map((e) => Results.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    data['results'] = results.map((e) => e.toJson()).toList();
    return data;
  }
}

class Results {
  Results({
    required this.id,
    required this.title,
    required this.authors,
    required this.translators,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    required this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
  });
  late final int id;
  late final String title;
  late final List<Authors> authors;
  late final List<dynamic> translators;
  late final List<String> subjects;
  late final List<String> bookshelves;
  late final List<String> languages;
  late final bool copyright;
  late final String mediaType;
  late final Formats formats;
  late final int downloadCount;

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    title = json['title'] ?? '';
    authors = List.from(json['authors'] ?? [])
        .map((e) => Authors.fromJson(e))
        .toList();
    translators = List.castFrom<dynamic, dynamic>(json['translators'] ?? []);
    subjects = List.castFrom<dynamic, String>(json['subjects'] ?? []);
    bookshelves = List.castFrom<dynamic, String>(json['bookshelves'] ?? []);
    languages = List.castFrom<dynamic, String>(json['languages'] ?? []);
    copyright = json['copyright'] ?? false;
    mediaType = json['media_type'] ?? '';
    formats = Formats.fromJson(json['formats'] ?? '');
    downloadCount = json['download_count'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['authors'] = authors.map((e) => e.toJson()).toList();
    data['translators'] = translators;
    data['subjects'] = subjects;
    data['bookshelves'] = bookshelves;
    data['languages'] = languages;
    data['copyright'] = copyright;
    data['media_type'] = mediaType;
    data['formats'] = formats.toJson();
    data['download_count'] = downloadCount;
    return data;
  }
}

class Authors {
  Authors({
    required this.name,
    required this.birthYear,
    required this.deathYear,
  });
  late final String name;
  late final int birthYear;
  late final int deathYear;

  Authors.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    birthYear = json['birth_year'] ?? 0;
    deathYear = json['death_year'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['birth_year'] = birthYear;
    data['death_year'] = deathYear;
    return data;
  }
}

class Formats {
  late String applicationEpubZip;
  late String textPlainCharsetUtf8;
  late String imageJpeg;
  late String applicationZip;
  late String applicationRdfXml;
  late String textHtmlCharsetUtf8;
  late String applicationXMobipocketEbook;
  late String textPlainCharsetUsAscii;
  late String textPlainCharsetIso88591;
  late String textHtmlCharsetIso88591;
  late String textHtmlCharsetUsAscii;
  late String textPlain;
  late String textRtf;
  late String textHtml;
  late String applicationPdf;

  Formats({
    required this.applicationEpubZip,
    required this.textPlainCharsetUtf8,
    required this.imageJpeg,
    required this.applicationZip,
    required this.applicationRdfXml,
    required this.textHtmlCharsetUtf8,
    required this.applicationXMobipocketEbook,
    required this.textPlainCharsetUsAscii,
    required this.textPlainCharsetIso88591,
    required this.textHtmlCharsetIso88591,
    required this.textHtmlCharsetUsAscii,
    required this.textPlain,
    required this.textRtf,
    required this.textHtml,
    required this.applicationPdf,
  });

  Formats.fromJson(Map<String, dynamic> json) {
    applicationEpubZip = json['application/epub+zip'] ?? '';
    textPlainCharsetUtf8 = json['text/plain; charset=utf-8'] ?? '';
    imageJpeg = json['image/jpeg'] ?? '';
    applicationZip = json['application/zip'] ?? '';
    applicationRdfXml = json['application/rdf+xml'] ?? '';
    textHtmlCharsetUtf8 = json['text/html; charset=utf-8'] ?? '';
    applicationXMobipocketEbook = json['application/x-mobipocket-ebook'] ?? '';
    textPlainCharsetUsAscii = json['text/plain; charset=us-ascii'] ?? '';
    textPlainCharsetIso88591 = json['text/plain; charset=iso-8859-1'] ?? '';
    textHtmlCharsetIso88591 = json['text/html; charset=iso-8859-1'] ?? '';
    textHtmlCharsetUsAscii = json['text/html; charset=us-ascii'] ?? '';
    textPlain = json['text/plain'] ?? '';
    textRtf = json['text/rtf'] ?? '';
    textHtml = json['text/html'] ?? '';
    applicationPdf = json['application/pdf'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['application/epub+zip'] = applicationEpubZip;
    data['text/plain; charset=utf-8'] = textPlainCharsetUtf8;
    data['image/jpeg'] = imageJpeg;
    data['application/zip'] = applicationZip;
    data['application/rdf+xml'] = applicationRdfXml;
    data['text/html; charset=utf-8'] = textHtmlCharsetUtf8;
    data['application/x-mobipocket-ebook'] = applicationXMobipocketEbook;
    data['text/plain; charset=us-ascii'] = textPlainCharsetUsAscii;
    data['text/plain; charset=iso-8859-1'] = textPlainCharsetIso88591;
    data['text/html; charset=iso-8859-1'] = textHtmlCharsetIso88591;
    data['text/html; charset=us-ascii'] = textHtmlCharsetUsAscii;
    data['text/plain'] = textPlain;
    data['text/rtf'] = textRtf;
    data['text/html'] = textHtml;
    data['application/pdf'] = applicationPdf;
    return data;
  }
}
