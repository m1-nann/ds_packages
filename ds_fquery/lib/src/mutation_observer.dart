import 'package:flutter/widgets.dart';
import '../ds_fquery.dart';
import 'mutation.dart';

/// A [MutationObserver] is a class which holds a [Mutation] and handles its execution.
class MutationObserver<TData, TError, TVariables, TContext> extends ChangeNotifier {
  final QueryClient client;
  late UseMutationOptions<TData, TError, TVariables, TContext> options;
  late Mutation<TData, TError, TVariables, TContext> mutation;
  TVariables? vars;

  MutationObserver({
    required this.client,
    required UseMutationOptions<TData, TError, TVariables, TContext> options,
  }) {
    mutation = Mutation<TData, TError, TVariables, TContext>(
      client: client,
      observer: this,
    );
    _setOptions(options);
  }

  /// Takes a [UseMutationOptions] and sets the [options] field.
  void _setOptions(
    UseMutationOptions<TData, TError, TVariables, TContext> options,
  ) {
    this.options = UseMutationOptions<TData, TError, TVariables, TContext>(
      mutationFn: options.mutationFn,
      onError: options.onError,
      onMutate: options.onMutate,
      onSettled: options.onSettled,
      onSuccess: options.onSuccess,
    );
  }

  /// This is usually called from the [useMutation] hook
  /// whenever there is any change in the options
  void updateOptions(
    UseMutationOptions<TData, TError, TVariables, TContext> options,
  ) {
    _setOptions(options);
  }

  /// This is "the" function responsible for the mutation.
  Future<void> mutate(TVariables variables) async {
    if (mutation.state.isPending) return;

    this.vars = variables;
    onMutationUpdated();

    mutation.dispatch(MutationDispatchAction.mutate, null);
    final ctx = await options.onMutate?.call(variables);

    TData? data;
    TError? error;
    try {
      error = null;
      data = await options.mutationFn(variables);
      mutation.dispatch(MutationDispatchAction.success, data);
      options.onSuccess?.call(data as TData, variables, ctx);
    } catch (err) {
      data = null;
      error = err as TError;
      mutation.dispatch(MutationDispatchAction.error, error);
      options.onError?.call(error as TError, variables, ctx);
    }
    options.onSettled?.call(data, error, variables, ctx);
  }

  /// Resets the mutation to its initial state.
  void reset() {
    mutation.dispatch(MutationDispatchAction.reset, null);
  }

  /// This is called from the [Mutation] class whenever the mutation state changes.
  /// It notifies the observer about the change and it also nofities the [useMutation] hook.
  void onMutationUpdated() {
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}
