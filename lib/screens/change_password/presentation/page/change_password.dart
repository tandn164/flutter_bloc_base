import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base/core/utils/constants.dart';
import 'package:flutter_bloc_base/core/utils/theme.dart';
import 'package:flutter_bloc_base/core/widgets/custom_snak_bar.dart';
import 'package:flutter_bloc_base/injection_container.dart';
import 'package:flutter_bloc_base/screens/change_password/presentation/blocs/change_password/bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final FocusNode _oldPasswordNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _passwordConfirmNode = FocusNode();
  final FocusNode _viewNode = FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  late CustomSnackBar _snackBar;
  late BooleanPrimitiveWrapper _obscureOldPasswordText;
  late BooleanPrimitiveWrapper _obscurePasswordText;
  late BooleanPrimitiveWrapper _obscurePasswordConfirmText;

  @override
  void initState() {
    super.initState();
    _obscureOldPasswordText = BooleanPrimitiveWrapper(true);
    _obscurePasswordText = BooleanPrimitiveWrapper(true);
    _obscurePasswordConfirmText = BooleanPrimitiveWrapper(true);
  }

  @override
  void dispose() {
    _oldPasswordNode.dispose();
    _passwordNode.dispose();
    _viewNode.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _snackBar = CustomSnackBar(key: const Key("snackbar"), scaffoldKey: _scaffoldKey);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_viewNode),
      child: Scaffold(
        key: _scaffoldKey,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: CustomColor.statusBarColor,
          ),
          child: _buildBody(context),
        ),
        appBar: AppBar(
          iconTheme: CustomTheme.mainTheme.iconTheme,
          backgroundColor: CustomColor.white,
          centerTitle: true,
          title: Text(
            "Change Password",
            style: CustomTheme.mainTheme.textTheme.displayLarge,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
    );
  }

  BlocProvider<ChangePasswordBloc> _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocProvider<ChangePasswordBloc>(
      create: (_) => sl<ChangePasswordBloc>(),
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(DEFAULT_PAGE_PADDING),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              _buildPasswordField(
                context,
                _oldPasswordNode,
                _oldPasswordController,
                _obscureOldPasswordText,
                "Old Password*",
                _passwordNode,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              _buildPasswordField(
                context,
                _passwordNode,
                _passwordController,
                _obscurePasswordText,
                "New Password*",
                _passwordConfirmNode,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              _buildPasswordField(
                context,
                _passwordConfirmNode,
                _passwordConfirmController,
                _obscurePasswordConfirmText,
                "Confirm Password*",
                _viewNode,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 14),
              ),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: _buildChangePasswordButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder _buildChangePasswordButton() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
       buildWhen: (prevState, currState) {
        if (currState is SuccessfulState) {
          _snackBar.hideAll();
          Navigator.pushNamedAndRemoveUntil(context, HOME_ROUTE, (r) => false);
        }
        return currState is! SuccessfulState;
      },
      builder: (context, state) {
        if (state is InitialState) {
          return ElevatedButton(
            key: const Key("changePassword"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              backgroundColor: CustomColor.logoBlue,
            ),
            onPressed: () {
              if (_oldPasswordController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _passwordConfirmController.text.isNotEmpty) {
                if (_passwordController.text ==
                    _passwordConfirmController.text) {
                  BlocProvider.of<ChangePasswordBloc>(context).add(
                    PasswordChangeEvent(
                      oldPassword: _oldPasswordController.text,
                      newPassword: _passwordController.text,
                    ),
                  );
                } else {
                  _snackBar.hideAll();
                  _snackBar.showErrorSnackBar("Passwords do not match");
                }
              } else {
                _snackBar.hideAll();
                _snackBar.showErrorSnackBar("Fileds can't be empty");
              }
            },
            child: Text(
              "CHANGE PASSWORD",
              style: CustomTheme.mainTheme.textTheme.labelLarge,
            ),
          );
        } else if (state is LoadingState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _snackBar.hideAll();
            _snackBar.showLoadingSnackBar();
          });
          return Container();
        } else if (state is ErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _snackBar.hideAll();
            _snackBar.showErrorSnackBar(state.message);
          });
        }
        return Container();
      },
    );
  }

  TextFormField _buildPasswordField(
    BuildContext context,
    FocusNode focusNode,
    TextEditingController controller,
    BooleanPrimitiveWrapper obscureText,
    String labelText,
    FocusNode nextNode,
  ) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText.value,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        focusColor: CustomColor.hintColor,
        hoverColor: CustomColor.hintColor,
        fillColor: CustomColor.textFieldBackground,
        filled: true,
        labelText: labelText,
        labelStyle: CustomTheme.mainTheme.textTheme.bodyMedium,
        suffixIcon: IconButton(
          icon: const Icon(Icons.remove_red_eye),
          color: CustomColor.hintColor,
          onPressed: () {
            setState(() {
              obscureText.value = !obscureText.value;
            });
          },
        ),
      ),
      cursorColor: CustomColor.hintColor,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, focusNode, nextNode);
      },
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

class BooleanPrimitiveWrapper {
  bool value;

  BooleanPrimitiveWrapper(this.value);
}
