import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../ds_fquery.dart';
import '../observer.dart';
import '../query.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class UseQueryResult<TData, TError> {
  final TData? data;
  final DateTime? dataUpdatedAt;
  final TError? error;
  final DateTime? errorUpdatedAt;
  final bool isError;
  final bool isLoading;
  final bool isFetching;
  final bool isSuccess;
  final QueryStatus status;
  final Future<void> Function() refetch;
  final bool isInvalidated;
  final bool isRefetchError;

  UseQueryResult({
    required this.data,
    required this.dataUpdatedAt,
    required this.error,
    required this.errorUpdatedAt,
    required this.isError,
    required this.isLoading,
    required this.isFetching,
    required this.isSuccess,
    required this.status,
    required this.refetch,
    required this.isInvalidated,
    required this.isRefetchError,
  });
}

class UseQueryOptions<TData, TError> {
  final bool enabled;
  final RefetchOnMount? refetchOnMount;
  final Duration? staleDuration;
  final Duration? cacheDuration;
  final Duration? refetchInterval;
  final int? retryCount;
  final Duration? retryDelay;

  UseQueryOptions({
    required this.enabled,
    this.refetchOnMount,
    this.staleDuration,
    this.cacheDuration,
    this.refetchInterval,
    this.retryCount,
    this.retryDelay,
  });
}

/// Builds and subscribes to a query stored in the cache.
/// Takes a query key and a fetcher function which either resolves or throws an error.
/// Returns a [UseQueryResult]
///
/// Example:
/// ```dart
/// // These are default configurations
/// final posts = useQuery(
///   ['posts'],
///   getPosts,
///   enabled: true,
///   cacheDuration: const Duration(minutes: 5),
///   refetchInterval: null // The query will not refetch by default,
///   refetchOnMount: RefetchOnMount.stale,
///   staleDuration: const Duration(seconds: 10),
/// );
/// ```
/// - `enabled` - specifies if the query fetcher function is automatically called when the widget renders, can be used for _dependent queries_.
/// - `cacheDuration` - specifies the duration unused/inactive cache data remains in memory; the cached data will be garbage collected after this duration. The longest duration will be used when different values are specified in multiple instances of the query.
/// - `refetchInterval` - specifies the time interval in which all queries will refetch the data, setting it to `null` (default) will turn off refetching
/// - `refetchOnMount` - specifies the behavior of the query instance when the widget is first built and the data is already available.
///   - `RefetchOnMount.always` - will always refetch when the widget is built.
///   - `RefetchOnMount.stale` - will fetch the data if it is stale (see `staleDuration`).
///   - `RefetchOnMount.never` - will never refetch.
/// - `staleDuration` - specifies the duration until the data becomes stale. This value applies to each query instance individually.

UseQueryResult<TData, TError> useQuery<TData, TError>(
  QueryKey queryKey,
  QueryFn<TData> fetcher, {
  // These options must match with the `UseQueryOptions`
  bool enabled = true,
  RefetchOnMount? refetchOnMount,
  Duration? staleDuration,
  Duration? cacheDuration,
  Duration? refetchInterval,
  int? retryCount,
  Duration? retryDelay,
}) {
  final options = useMemoized(
    () => UseQueryOptions<TData, TError>(
      enabled: enabled,
      refetchOnMount: refetchOnMount,
      staleDuration: staleDuration,
      cacheDuration: cacheDuration,
      refetchInterval: refetchInterval,
      retryCount: retryCount,
      retryDelay: retryDelay,
    ),
    [
      enabled,
      refetchOnMount,
      staleDuration,
      cacheDuration,
      refetchInterval,
      retryCount,
      retryDelay,
    ],
  );
  final client = useQueryClient();
  currentQuery() => client.queryCache.queries[queryKey.lock];
  final init = useMemoized<(Observer<TData, TError>, int)>(
    () {
      final newObserver = Observer<TData, TError>(
        queryKey,
        fetcher,
        client: client,
        options: options,
      );
      return (newObserver, currentQuery().hashCode);
    },

    // The first value is to make sure that the observer
    // is rebuilt when query key changes.
    //
    // The second value is to make sure that the observer
    // is rebuilt when query itself changes in the cache, typically
    // when `QueryClient.removeQueries` is called, followed by
    // `QueryClient.setQueryData` (creating a new query in the cache)
    [queryKey.lock],
  );

  final observer = useMemoized<Observer<TData, TError>>(
    () {
      if (init.$2 == currentQuery().hashCode) {
        return init.$1;
      } else {
        final newObserver = Observer<TData, TError>(
          queryKey,
          fetcher,
          client: client,
          options: options,
        );
        return newObserver;
      }
    },
    // The first value is to make sure that the observer
    // is rebuilt when query key changes.
    //
    // The second value is to make sure that the observer
    // is rebuilt when query itself changes in the cache, typically
    // when `QueryClient.removeQueries` is called, followed by
    // `QueryClient.setQueryData` (creating a new query in the cache)
    [init, currentQuery()?.hashCode],
  );

  // This subscribes to the observer
  // and rebuilds the widgets on updates.
  useListenable<Observer<TData, TError>>(observer);

  useEffect(
    () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        observer.updateOptions(options);
      });
      return null;
    },
    [observer, options],
  );

  useEffect(
    () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        observer.initialize();
      });
      return () {
        observer.destroy();
      };
    },
    [observer],
  );

  return UseQueryResult<TData, TError>(
    data: observer.query.state.data,
    dataUpdatedAt: observer.query.state.dataUpdatedAt,
    error: observer.query.state.error,
    errorUpdatedAt: observer.query.state.errorUpdatedAt,
    isError: observer.query.state.isError,
    isLoading: observer.query.state.isLoading,
    isFetching: observer.query.state.isFetching,
    isSuccess: observer.query.state.isSuccess,
    status: observer.query.state.status,
    refetch: observer.fetch,
    isInvalidated: observer.query.state.isInvalidated,
    isRefetchError: observer.query.state.isRefetchError,
  );
}
