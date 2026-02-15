/// Posts feature barrel file
library posts;

// Domain
export 'domain/entities/post_entity.dart';
export 'domain/repositories/posts_repository.dart';
export 'domain/usecases/get_posts.dart';
export 'domain/usecases/get_post_by_id.dart';
export 'domain/usecases/create_post.dart';
export 'domain/usecases/update_post.dart';
export 'domain/usecases/delete_post.dart';

// Data
export 'data/models/post_model.dart';
export 'data/datasources/posts_remote_datasource.dart';
export 'data/datasources/posts_local_datasource.dart';
export 'data/repositories/posts_repository_impl.dart';

// Presentation
export 'presentation/bloc/posts_bloc.dart';
export 'presentation/pages/posts_page.dart';
export 'presentation/pages/post_detail_page.dart';
export 'presentation/widgets/post_card.dart';
export 'presentation/widgets/loading_widget.dart';
export 'presentation/widgets/error_widget.dart';
