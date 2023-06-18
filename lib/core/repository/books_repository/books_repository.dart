import 'dart:io';

import 'package:dio/dio.dart';
import 'package:endpoint_layer/utils/constants/auth_endpoint.dart';
import 'package:network_layer/api_service.dart';
import 'package:endpoint_layer/endpoint_layer.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:network_layer/utils/exceptions/custom_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worldofbooks/core/logs/primary_logger.dart';
import 'package:worldofbooks/core/models/books_response_model.dart';

class BooksRepository {
  ApiService apiService;
  BooksRepository(this.apiService);

  CancelToken cancelToken = CancelToken();

  Future<Either<BooksResponseModel, CustomException>> getBooks(
    Map<String, dynamic> requestData,
  ) async {
    final res = await apiService
        .getCollectionData<Either<BooksResponseModel, CustomException>>(
      endpoint: ApiEndpoint.books(BooksEndpoint.getBooks),
      queryParams: requestData,
      cancelToken: cancelToken,
      requiresAuthToken: false,
      converter: converterGetBooks,
      errorHandler: errorHandlerGetBooks,
    );

    return res;
  }

  Either<BooksResponseModel, CustomException> converterGetBooks(
      dynamic resBody) {
    final result = BooksResponseModel.fromJson(resBody);
    return Left(result);
  }

  Either<BooksResponseModel, CustomException> errorHandlerGetBooks(
      CustomException errBody) {
    return Right(errBody);
  }

  Future<File> downloadFile(Uri url, String fileName) async {
    var req = await http.Client().get(url);
    var dir = (await getApplicationDocumentsDirectory()).path;
    var file = File('$dir/$fileName');
    primaryLogger.i('Zip filed saved at : ${file.path}');
    return file.writeAsBytes(req.bodyBytes);
  }
}
