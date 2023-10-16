import 'package:dartz/dartz.dart';
import 'package:montrex/domain/entities/movie.dart';
import 'package:montrex/domain/repositories/movie_repository.dart';
import 'package:montrex/common/failure.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
