// lib/screens/forgot_password_dialog.dart - YENİ DOSYA
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordDialog extends StatefulWidget {
  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _emailSent = false;

  void _sendPasswordResetEmail() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen e-posta adresinizi girin.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });

      print("✅ Şifre sıfırlama e-postası gönderildi: ${_emailController.text}");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print("❌ Şifre sıfırlama hatası: $e");
      
      String errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı.";
            break;
          case 'invalid-email':
            errorMessage = "Geçersiz e-posta adresi.";
            break;
          case 'network-request-failed':
            errorMessage = "İnternet bağlantınızı kontrol edin.";
            break;
          default:
            errorMessage = "Hata: ${e.message}";
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.lock_reset, color: Colors.blue),
          SizedBox(width: 10),
          Text('Şifremi Unuttum'),
        ],
      ),
      content: _emailSent
          ? _buildSuccessContent()
          : _buildFormContent(),
      actions: _emailSent
          ? _buildSuccessActions()
          : _buildFormActions(),
    );
  }

  Widget _buildFormContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Şifrenizi sıfırlamak için e-posta adresinizi girin. Size şifre sıfırlama bağlantısı göndereceğiz.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'E-posta Adresiniz',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
            hintText: 'ornek@email.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 50),
        SizedBox(height: 16),
        Text(
          'Şifre Sıfırlama E-postası Gönderildi!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          '${_emailController.text} adresine şifre sıfırlama bağlantısı gönderdik. Lütfen e-postanızı kontrol edin.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildFormActions() {
    return [
      TextButton(
        onPressed: _closeDialog,
        child: Text('İptal'),
      ),
      ElevatedButton(
        onPressed: _isLoading ? null : _sendPasswordResetEmail,
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text('Gönder'),
      ),
    ];
  }

  List<Widget> _buildSuccessActions() {
    return [
      ElevatedButton(
        onPressed: _closeDialog,
        child: Text('Tamam'),
      ),
    ];
  }
}