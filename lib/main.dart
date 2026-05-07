import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'cubits/reading_list_cubit.dart';
import 'cubits/search_cubit.dart';
import 'models/book_api_service.dart';
import 'models/reading_list_repository.dart';
import 'screens/search_screen.dart';
import 'theme.dart';

Future<void> main() async { // async/await to load API key
  await dotenv.load(fileName: '.env');
  runApp(const BookFinderApp());
}

class BookFinderApp extends StatelessWidget {
  const BookFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [ // App shares same instance of services
        RepositoryProvider(create: (_) => BookApiService()),
        RepositoryProvider(create: (_) => ReadingListRepository()),
      ],
      child: MultiBlocProvider( // Shared Cubits/state
        providers: [
          BlocProvider(create: (ctx) => SearchCubit(ctx.read<BookApiService>())),
          BlocProvider(create: (ctx) => ReadingListCubit(ctx.read<ReadingListRepository>())),
        ],
        child: MaterialApp(
          title: 'Book Finder',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(), // Whole app shares theme/styling
          home: const SearchScreen(),
        ),
      ),
    );
  }
}
