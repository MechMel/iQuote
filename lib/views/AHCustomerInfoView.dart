import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_InputFields.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';

class AHCustomerInfoView extends StatelessWidget {
  final void Function(bool) tellParentThatCustomerInfoHasChanged;
  final AQI_QuoteController quote;
  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _contactNameFocusNode = FocusNode();
  final FocusNode _contactEmailAddressFocusNode = FocusNode();
  final FocusNode _companyAddressLine1FocusNode = FocusNode();
  final FocusNode _companyAddressLine2FocusNode = FocusNode();

  AHCustomerInfoView(this.quote, this.tellParentThatCustomerInfoHasChanged,
      {Key key})
      : super(key: key);
  // TODO: there are a lot of bugs with the input fields, fix them
  void applyCustomerInfoChanges(bool shouldReloadUI) {
    if (tellParentThatCustomerInfoHasChanged != null) {
      tellParentThatCustomerInfoHasChanged(shouldReloadUI);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Customer Info Header
        AHHeader("Customer Info"),

        // Company Name
        Container(
          height: AHStyle.lineHeight,
          child: AHTextField(
            //focusNode: _companyNameFocusNode,
            getValue: () {
              return quote.companyName.value;
            },
            setValue: (value) {
              quote.companyName.value = value;
              applyCustomerInfoChanges(false);
            },
            onSubmitted: () {
              applyCustomerInfoChanges(true);
            },
            hintText: "Business Name",
            icon: Icon(Icons.business),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
          ),
        ),

        // Contact Name
        Container(
          height: AHStyle.lineHeight,
          child: AHTextField(
            //focusNode: _contactNameFocusNode,
            getValue: () {
              return quote.contactName.value;
            },
            setValue: (value) {
              quote.contactName.value = value;
              applyCustomerInfoChanges(false);
            },
            onSubmitted: () {
              applyCustomerInfoChanges(true);
            },
            hintText: "Contact Name",
            icon: Icon(Icons.person),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
          ),
        ),

        // Contact Email
        Container(
          height: AHStyle.lineHeight,
          child: AHTextField(
            //focusNode: _contactEmailAddressFocusNode,
            getValue: () {
              return quote.contactEmailAddress.value;
            },
            setValue: (value) {
              quote.contactEmailAddress.value = value;
              applyCustomerInfoChanges(false);
            },
            onSubmitted: () {
              applyCustomerInfoChanges(true);
            },
            keyboardType: TextInputType.emailAddress,
            hintText: "Contact Email Address",
            icon: Icon(Icons.email),
            textInputAction: TextInputAction.done,
          ),
        ),

        // Company Address Line 2
        Container(
          height: AHStyle.lineHeight,
          child: AHTextField(
            //focusNode: _companyAddressLine1FocusNode,
            getValue: () {
              return quote.companyAddressLine1.value;
            },
            setValue: (value) {
              applyCustomerInfoChanges(false);
              quote.companyAddressLine1.value = value;
            },
            onSubmitted: () {
              applyCustomerInfoChanges(true);
            },
            hintText: "Street Address",
            icon: Icon(Icons.place),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
          ),
        ),

        // Company Address Line 2
        Container(
          height: AHStyle.lineHeight,
          child: AHTextField(
            //focusNode: _companyAddressLine2FocusNode,
            getValue: () {
              return quote.companyAddressLine2.value;
            },
            setValue: (value) {
              applyCustomerInfoChanges(false);
              quote.companyAddressLine2.value = value;
            },
            onSubmitted: () {
              applyCustomerInfoChanges(true);
            },
            hintText: "City, State 0000",
            icon: Icon(Icons.place),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
          ),
        ),
      ],
    );
  }
}
