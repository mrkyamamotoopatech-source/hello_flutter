import '../data/post_repository.dart';
import '../models/post.dart';

class FetchPostsUseCase {
  final PostRepository _repo;

  FetchPostsUseCase(this._repo);

  Future<List<Post>> call(int page) => _repo.fetch(page);
}
