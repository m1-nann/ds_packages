import 'package:flutter_hooks/flutter_hooks.dart';
import '../query_client.dart';
import '../query_client_provider.dart';

/// Obtains the provided instance of [QueryClient]
/// from the nearest [QueryClientProvider] ancestor.
QueryClient useQueryClient() {
  final context = useContext();
  return QueryClientProvider.of(context).queryClient;
}
