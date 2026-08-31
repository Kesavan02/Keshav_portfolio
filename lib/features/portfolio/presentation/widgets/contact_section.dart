import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://formsubmit.co/ajax/keshavsreenivas@gmail.com'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'number': _numberController.text,
          'message': _messageController.text,
          '_subject': 'New Portfolio Message from ${_nameController.text}',
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Message sent successfully! Thank you for reaching out.',
              ),
              backgroundColor: AppColors.accentCyan,
            ),
          );
          _formKey.currentState!.reset();
          _nameController.clear();
          _emailController.clear();
          _numberController.clear();
          _messageController.clear();
        }
      } else {
        _handleFallback('Opening Gmail compose tab...');
      }
    } catch (e) {
      _handleFallback('Opening Gmail compose tab...');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    String gmailUrl = 'https://mail.google.com/mail/?view=cm&fs=1&to=$email';
    if (subject != null) gmailUrl += '&su=${Uri.encodeComponent(subject)}';
    if (body != null) gmailUrl += '&body=${Uri.encodeComponent(body)}';

    final uri = Uri.parse(gmailUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: '_blank',
        );
        return;
      }
    } catch (_) {}

    final mailtoUri = Uri.parse('mailto:$email');
    await launchUrl(mailtoUri);
  }

  void _handleFallback(String errorMessage) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 4),
        ),
      );
    }

    _launchEmail(
      'keshavsreenivas@gmail.com',
      subject: 'Portfolio Contact from ${_nameController.text}',
      body:
          'Name: ${_nameController.text}\n'
          'Number: ${_numberController.text}\n'
          'Email: ${_emailController.text}\n\n'
          'Message:\n${_messageController.text}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobileScreen = MediaQuery.of(context).size.width < 900;
    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        children: [
          // Main Content Area
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobileScreen ? 24 : 50,
              vertical: 100,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 900;

                if (isMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(isMobile: true),
                      const SizedBox(height: 60),
                      _buildFormSection(),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: _buildInfoSection(isMobile: false),
                      ),
                    ),
                    Expanded(flex: 1, child: _buildFormSection()),
                  ],
                );
              },
            ),
          ),

          // Footer
          // _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Me',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.accentCyan,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Let's Connect & Create\nSomething Great",
          style: TextStyle(
            fontSize: isMobile ? 32 : 40,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          "Have a project in mind or just want to chat about creative strategies? I'd love to connect! Feel free to reach out via email or social media.",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 50),

        // Contact Details
        _buildContactDetailItem(Icons.phone, '+91 9629637971'),
        const SizedBox(height: 25),
        _buildContactDetailItem(
          Icons.email,
          'keshavsreenivas@gmail.com',
          isLink: true,
        ),
        const SizedBox(height: 50),

        // Socials
        Row(
          children: [
            _buildSocialIcon(
              const FaIcon(
                FontAwesomeIcons.linkedinIn,
                color: Colors.white,
                size: 20,
              ),
              'https://www.linkedin.com/in/kesavan-k-224b09253',
            ),
            const SizedBox(width: 20),
            _buildSocialIcon(
              const FaIcon(
                FontAwesomeIcons.github,
                color: Colors.white,
                size: 20,
              ),
              'https://github.com/Kesavan02',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactDetailItem(
    IconData icon,
    String text, {
    bool isLink = false,
  }) {
    return MouseRegion(
      cursor: isLink ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isLink ? () => _launchEmail(text) : null,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.accentCyan, size: 24),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                decoration: isLink
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(Widget iconWidget, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(url)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow.withValues(alpha: 0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: iconWidget,
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              label: 'Name',
              hint: 'Enter your name',
              controller: _nameController,
            ),
            const SizedBox(height: 25),
            _buildInputField(
              label: 'Number',
              hint: 'Enter your Number',
              controller: _numberController,
              isPhone: true,
            ),
            const SizedBox(height: 25),
            _buildInputField(
              label: 'Email',
              hint: 'Enter your Email',
              controller: _emailController,
              isEmail: true,
            ),
            const SizedBox(height: 25),
            _buildInputField(
              label: 'Message',
              hint: 'Type Message here',
              controller: _messageController,
              maxLines: 4,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGlow,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: AppColors.primaryGlow.withValues(alpha: 0.5),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Send Message',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : (isPhone ? TextInputType.phone : TextInputType.text),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            if (isEmail && !value.contains('@')) {
              return 'Enter a valid email';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
            prefixIcon: isPhone
                ? const Icon(Icons.public, color: Colors.white30, size: 20)
                : null,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.03),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGlow),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildFooter() {
  //   return Container(
  //     width: double.infinity,
  //     color: AppColors.navBg,
  //     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
  //     child: Column(
  //       children: [
  //         LayoutBuilder(
  //           builder: (context, constraints) {
  //             final isMobile = constraints.maxWidth < 700;
  //             if (isMobile) {
  //               return Column(
  //                 children: [
  //                   _buildFooterLogo(),
  //                   const SizedBox(height: 30),
  //                   _buildFooterLinks(),
  //                   const SizedBox(height: 30),
  //                   _buildSocialIcon(
  //                     const FaIcon(
  //                       FontAwesomeIcons.linkedinIn,
  //                       color: Colors.white,
  //                       size: 20,
  //                     ),
  //                     'https://www.linkedin.com/in/kesavan-k-224b09253',
  //                   ),
  //                 ],
  //               );
  //             }
  //             return Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 _buildFooterLogo(),
  //                 _buildFooterLinks(),
  //                 _buildSocialIcon(
  //                   const FaIcon(
  //                     FontAwesomeIcons.linkedinIn,
  //                     color: Colors.white,
  //                     size: 20,
  //                   ),
  //                   'https://www.linkedin.com/in/kesavan-k-224b09253',
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //         const SizedBox(height: 30),
  //         const Divider(color: Colors.white12),
  //         const SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text(
  //               '©2024 Kesavan. All rights reserved.',
  //               style: TextStyle(color: Colors.white54, fontSize: 12),
  //             ),
  //             RichText(
  //               text: const TextSpan(
  //                 style: TextStyle(color: Colors.white54, fontSize: 12),
  //                 children: [
  //                   TextSpan(text: 'Design by '),
  //                   TextSpan(
  //                     text: 'Kesavan',
  //                     style: TextStyle(decoration: TextDecoration.underline),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFooterLogo() {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(
  //         Icons.spa,
  //         color: const Color(0xFFB594F6),
  //         size: 30,
  //       ), // Abstract leaf icon resembling reference
  //       const SizedBox(width: 10),
  //       const Text(
  //         'Kesavan',
  //         style: TextStyle(
  //           fontSize: 24,
  //           fontWeight: FontWeight.bold,
  //           fontFamily: 'Roboto',
  //           color: Colors.white,
  //           fontStyle: FontStyle.italic,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildFooterLinks() {
  //   return Wrap(
  //     spacing: 30,
  //     runSpacing: 15,
  //     alignment: WrapAlignment.center,
  //     children: [
  //       _buildFooterLink('Home'),
  //       _buildFooterLink('About Me'),
  //       _buildFooterLink('My Work'),
  //       _buildFooterLink('Contact'),
  //     ],
  //   );
  // }

  // Widget _buildFooterLink(String title) {
  //   return MouseRegion(
  //     cursor: SystemMouseCursors.click,
  //     child: Text(
  //       title,
  //       style: const TextStyle(
  //         color: Colors.white70,
  //         fontSize: 14,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //   );
  // }
}
