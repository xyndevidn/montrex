import 'package:dartz/dartz.dart';
import 'package:montrex/domain/entities/movie.dart';
import 'package:montrex/domain/repositories/movie_repository.dart';
import 'package:montrex/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
