import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:word_mate/l10n/app_localizations.dart';
import 'package:word_mate/gen/assets.gen.dart';
import 'package:word_mate/injector.dart';
import 'package:word_mate/presentation/views/register/bloc/register_bloc.dart';
import 'package:word_mate/presentation/views/register/bloc/register_event.dart';
import 'package:word_mate/presentation/views/register/bloc/register_state.dart';
import 'package:word_mate/presentation/widgets/register/avatar_selector.dart';
import 'package:word_mate/presentation/widgets/register/custom_text_field.dart';
import 'package:word_mate/presentation/widgets/register/glass_container.dart';
import 'package:word_mate/presentation/widgets/button_widget.dart';
import 'package:word_mate/presentation/widgets/register/glowing_text.dart';
import 'package:word_mate/presentation/widgets/register/gradient_background.dart';
import 'package:word_mate/presentation/widgets/page_indicator.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<RegisterBloc>(
      create: (context) => injector.get<RegisterBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: GradientBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 60.h),
                        const GlowingText('WORDY'),
                        SizedBox(height: 12.h),
                        Text(
                          l10n.registerSubtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 48.h),
                        Text(
                          l10n.chooseAvatar,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          buildWhen: (previous, current) => previous.selectedAvatar != current.selectedAvatar,
                          builder: (context, state) {
                            return AvatarSelector(
                              avatars: [
                                Assets.images.fox.path,
                                Assets.images.octopus.path,
                                Assets.images.moon.path,
                                Assets.images.thunder.path,
                                Assets.images.darts.path,
                                Assets.images.books.path,
                              ],
                              selectedAvatar: state.selectedAvatar,
                              onAvatarSelected: (avatar) {
                                context.read<RegisterBloc>().add(SelectAvatarEvent(avatar));
                              },
                            );
                          },
                        ),
                        SizedBox(height: 40.h),
                        GlassContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.whatShouldWeCallYou,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              CustomTextField(
                                hintText: l10n.nicknameHint,
                                onChanged: (val) {
                                  context.read<RegisterBloc>().add(UpdateNicknameEvent(val));
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        BlocConsumer<RegisterBloc, RegisterState>(
                          listenWhen: (previous, current) => previous.status != current.status,
                          listener: (context, state) {
                            if (state.status == RegisterStatus.success) {
                              context.go('/daily-goal');
                            }
                          },
                          builder: (context, state) {
                            final isSubmitting = state.status == RegisterStatus.submitting;
                            return ButtonWidget.primary(
                              title: isSubmitting ? l10n.saving : l10n.letsGo,
                              iconAfter: isSubmitting
                                  ? SizedBox(
                                      width: 20.sp,
                                      height: 20.sp,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      Icons.arrow_forward,
                                      color: state.isValid
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.5),
                                      size: 20.sp,
                                    ),
                              onPressed: state.isValid && !isSubmitting
                                  ? () {
                                      context.read<RegisterBloc>().add(SubmitRegisterEvent());
                                    }
                                  : null,
                            );
                          },
                        ),
                        SizedBox(height: 40.h),
                        const AppPageIndicator(totalPages: 2, currentPage: 0),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
