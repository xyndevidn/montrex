import 'package:dartz/dartz.dart';
import 'package:montrex/domain/entities/movie_detail.dart';
import 'package:montrex/domain/repositories/movie_repository.dart';
import 'package:montrex/common/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
