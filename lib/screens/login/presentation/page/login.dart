import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base/core/utils/constants.dart';
import 'package:flutter_bloc_base/core/utils/theme.dart';
import 'package:flutter_bloc_base/core/widgets/custom_snak_bar.dart';
import 'package:flutter_bloc_base/screens/login/presentation/blocs/user_login/bloc.dart';

import '../../../../injection_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _viewNode = FocusNode();

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  late CustomSnackBar _snackBar;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _viewNode.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
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
      ),
    );
  }

  BlocProvider<UserLoginBloc> _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isKeyboardOpen = (MediaQuery.of(context).viewInsets.bottom > 0);
    return BlocProvider<UserLoginBloc>(
      create: (_) => sl<UserLoginBloc>(),
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(DEFAULT_PAGE_PADDING),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildHeader(isKeyboardOpen),
              _buildEmailField(context),
              const Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              _buildPasswordField(context),
              const Padding(
                padding: EdgeInsets.only(top: 14),
              ),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: _buildLoginButton(),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 14),
              ),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: _buildSkipLoginButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isKeyboardOpen) {
    if (!isKeyboardOpen) {
      return Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 74),
          ),
          const SizedBox(
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            "Login",
            style: CustomTheme.mainTheme.textTheme.displayLarge,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 14),
          ),
        ],
      );
    }
    return const Padding(
      padding: EdgeInsets.only(top: 74),
    );
  }

  BlocBuilder _buildLoginButton() {
    return BlocBuilder<UserLoginBloc, UserLoginState>(
      buildWhen: (prevState, currState) {
        if (currState is LoggedState) {
          _snackBar.hideAll();
          Navigator.pushNamedAndRemoveUntil(context, HOME_ROUTE, (r) => false);
        }
        return currState is! LoggedState;
      },
      builder: (context, state) {
        if (state is NotLoggedState || state is ErrorState) {
          if (state is ErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _snackBar.hideAll();
              _snackBar.showErrorSnackBar(state.message);
            });
          }
          return ElevatedButton(
            key: const Key("login"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              backgroundColor: CustomColor.logoBlue,
            ),
            onPressed: () {
              BlocProvider.of<UserLoginBloc>(context).add(
                LoginEvent(
                  _emailEditingController.text,
                  _passwordEditingController.text,
                ),
              );
            },
            child: Text(
              "LOGIN",
              style: CustomTheme.mainTheme.textTheme.labelLarge,
            ),
          );
        } else if (state is LoadingState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _snackBar.hideAll();
            _snackBar.showLoadingSnackBar();
          });
          return Container();
        }
        return Container();
      },
    );
  }

  BlocBuilder _buildSkipLoginButton() {
    return BlocBuilder<UserLoginBloc, UserLoginState>(
      buildWhen: (prevState, currState) {
        if (currState is LoggedState) {
          _snackBar.hideAll();
          Navigator.pushNamedAndRemoveUntil(context, HOME_ROUTE, (r) => false);
        }
        return currState is! LoggedState;
      },
      builder: (context, state) {
        if (state is NotLoggedState || state is ErrorState) {
          if (state is ErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _snackBar.hideAll();
              _snackBar.showErrorSnackBar(state.message);
            });
          }
          return ElevatedButton(
            key: const Key("skipLogin"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              backgroundColor: CustomColor.logoBlue,
            ),
            onPressed: () {
              BlocProvider.of<UserLoginBloc>(context).add(
                SkipLoginEvent(),
              );
            },
            child: Text(
              "SKIP LOGIN",
              style: CustomTheme.mainTheme.textTheme.labelLarge,
            ),
          );
        } else if (state is LoadingState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _snackBar.hideAll();
            _snackBar.showLoadingSnackBar();
          });
          return Container();
        }
        return Container();
      },
    );
  }

  TextFormField _buildEmailField(BuildContext context) {
    return TextFormField(
      focusNode: _emailNode,
      controller: _emailEditingController,
      keyboardType: TextInputType.emailAddress,
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
        labelText: "Email*",
        labelStyle: CustomTheme.mainTheme.textTheme.bodyLarge,
      ),
      cursorColor: CustomColor.hintColor,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _emailNode, _passwordNode);
      },
    );
  }

  TextFormField _buildPasswordField(BuildContext context) {
    return TextFormField(
      focusNode: _passwordNode,
      controller: _passwordEditingController,
      obscureText: _obscureText,
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
        labelText: "Password*",
        labelStyle: CustomTheme.mainTheme.textTheme.bodyMedium,
        suffixIcon: IconButton(
          icon: const Icon(Icons.remove_red_eye),
          color: CustomColor.hintColor,
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      cursorColor: CustomColor.hintColor,
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
