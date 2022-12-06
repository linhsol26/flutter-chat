import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/error_widget.dart';
import 'package:whatsapp_ui/core/presentation/widgets/loading_widget.dart';
import 'package:whatsapp_ui/routing/app_router.dart';
import 'package:whatsapp_ui/status/shared/providers.dart';

class StatusScreen extends HookConsumerWidget {
  const StatusScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(getStatusProvider);
    return statusAsync.when(
      data: (async) {
        if (async.isSuccess()) {
          final statusList = async.getSuccess() ?? [];
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: statusList.length,
              itemBuilder: (_, index) {
                final status = statusList[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () => context.goNamed(AppRoute.statusView.name, extra: status),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            status.username,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              status.profilePic,
                            ),
                            radius: 30,
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: brownColor, indent: 85),
                  ],
                );
              });
        } else {
          return CustomErrorWidget(
              msg: async.getError()?.when(
                    (msg) => msg ?? 'Something went wrong.',
                    noConnection: () => 'No connection.',
                  ));
        }
      },
      error: (error, _) => const CustomErrorWidget(),
      loading: () => const LoadingWidget(),
    );
  }
}
