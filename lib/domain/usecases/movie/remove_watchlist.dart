import 'package:dartz/dartz.dart';
import 'package:montrex/common/failure.dart';
import 'package:montrex/domain/entities/movie_detail.dart';
import 'package:montrex/domain/repositories/movie_repository.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
