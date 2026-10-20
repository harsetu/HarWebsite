import 'package:core/bloc/contact_cubit.dart';
import 'package:core/constants/color_manager.dart';
import 'package:core/di/service_injection.dart';
import 'package:core/utils/allowed_input_enum.dart';
import 'package:core/widget/base_button.dart';
import 'package:core/widget/base_edit_text.dart';
import 'package:core/widget/base_screen.dart';
import 'package:core/widget/base_svg_image.dart';
import 'package:core/widget/base_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/site_content.dart';
import '../../widgets/responsive_center.dart';
import '../../widgets/site_scaffold.dart';

class ContactPage extends BaseStatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 800;

    return BlocProvider<ContactCubit>(
      create: (_) => getIt<ContactCubit>(),
      child: SiteScaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ResponsiveCenter(
            maxWidth: isCompact ? 720 : 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseTextView(
                  text: 'Contact Us',
                  isLocalizeText: false,
                  useAutoTranslation: false,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 10),
                BaseTextView(
                  text:
                      'Have a project or an enquiry? Send us a message and we\'ll get back to you.',
                  isLocalizeText: false,
                  useAutoTranslation: false,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorManager.colorTextLight,
                  ),
                ),
                const SizedBox(height: 36),
                if (isCompact) ...[
                  const _EnquiryForm(),
                  const SizedBox(height: 40),
                  const _ContactInfoCard(),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(flex: 3, child: _EnquiryForm()),
                      SizedBox(width: 48),
                      Expanded(flex: 2, child: _ContactInfoCard()),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Phone / email / social details shown alongside the enquiry form, for
/// people who'd rather reach out directly than fill in a form.
class _ContactInfoCard extends StatelessWidget {
  const _ContactInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: ColorManager.colorBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorManager.dividerColour),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseTextView(
            text: 'Get in Touch',
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _ContactInfoRow(
            icon: Icons.call_outlined,
            text: SiteContent.contactPhone,
            onTap: () => launchUrl(
              Uri(
                scheme: 'tel',
                path: SiteContent.contactPhone.replaceAll(' ', ''),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _ContactInfoRow(
            icon: Icons.email_outlined,
            text: SiteContent.contactEmail,
            onTap: () => launchUrl(
              Uri(scheme: 'mailto', path: SiteContent.contactEmail),
            ),
          ),
          const SizedBox(height: 28),
          BaseTextView(
            text: 'Follow us',
            isLocalizeText: false,
            useAutoTranslation: false,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _SocialIconButton(
                assetPath: 'assets/images/icon_instagram.svg',
                url: SiteContent.instagramUrl,
              ),
              const SizedBox(width: 12),
              _SocialIconButton(
                assetPath: 'assets/images/icon_facebook.svg',
                url: SiteContent.facebookUrl,
              ),
              const SizedBox(width: 12),
              _SocialIconButton(
                assetPath: 'assets/images/icon_linkedin.svg',
                url: SiteContent.linkedinUrl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactInfoRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ColorManager.primaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: BaseTextView(
              text: text,
              isLocalizeText: false,
              useAutoTranslation: false,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final String assetPath;
  final String url;

  const _SocialIconButton({required this.assetPath, required this.url});

  Future<void> _open() =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _open,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.primaryColor.withAlpha(25),
        ),
        child: BaseSvgImage(assetPath: assetPath),
      ),
    );
  }
}

class _EnquiryForm extends StatefulWidget {
  const _EnquiryForm();

  @override
  State<_EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<_EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ContactCubit>().submitEnquiry(
      endpoint: SiteContent.contactFormEndpoint,
      toEmail: SiteContent.contactEmail,
      subject: 'New Enquiry from ${SiteContent.companyName} Website',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      message: _messageController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state is ContactSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Thanks! Your enquiry has been sent — we\'ll get back to you soon.',
              ),
            ),
          );
          _formKey.currentState?.reset();
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _messageController.clear();
          context.read<ContactCubit>().reset();
        } else if (state is ContactFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isSubmitting = state is ContactSubmitting;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseEditText(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Enter your name',
                allowedInput: AllowedInput.alphabetsWithSpaces,
                minLength: 2,
              ),
              const SizedBox(height: 20),
              BaseEditText(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                allowedInput: AllowedInput.email,
                minLength: 5,
                validator: (value) {
                  if (value == null ||
                      !value.contains('@') ||
                      !value.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              BaseEditText(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                allowedInput: AllowedInput.phoneNumber,
              ),
              const SizedBox(height: 20),
              BaseEditText(
                controller: _messageController,
                labelText: 'Message',
                hintText: 'Tell us about your project or enquiry',
                allowedInput: AllowedInput.everything,
                minLength: 10,
                maxLines: 5,
              ),
              const SizedBox(height: 28),
              BaseButton(
                buttonText: 'Send Enquiry',
                isLoading: isSubmitting,
                buttonHorizontalPadding: 32,
                onPressed: () => _submit(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
