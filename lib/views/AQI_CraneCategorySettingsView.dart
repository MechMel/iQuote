import 'package:axiom_hoist_quote_calculator/M2/M2ObjectWrapperForControllers.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_CraneCategoriesController.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_InputFields.dart';
import 'package:flutter/material.dart';

class AQI_CraneCategorySettingsView extends StatelessWidget {
  // TODO: Clean up this class later
  final int craneCategoryID;
  final void Function() _tellParentThisWidgetHasChanged;

  bool get isActiveCraneCategory {
    return AQI_CraneCategoriesController.isCraneCategoryActive(craneCategoryID);
  }

  Color get _categoryColorBasedOnShowHide {
    if (isActiveCraneCategory) {
      return AHStyle.COLOR_BLACK;
    } else {
      return AHStyle.COLOR_HINT;
    }
  }

  Color get _categoryNameTextColor {
    if (isActiveCraneCategory &&
        _craneCategoryName.value == _craneCategoryName.defaultValue) {
      return AHStyle.COLOR_ERROR;
    } else {
      return _categoryColorBasedOnShowHide;
    }
  }

  Color get _categoryNameHintColor {
    if (isActiveCraneCategory) {
      if (_craneCategoryName.value == _craneCategoryName.defaultValue) {
        return AHStyle.COLOR_ERROR;
      } else {
        return AHStyle.COLOR_HINT;
      }
    } else {
      return _categoryColorBasedOnShowHide;
    }
  }

  Color get _periodicLabelColor {
    if (isActiveCraneCategory &&
        _craneCategoryDefaultPeriodicManHours.value ==
            _craneCategoryDefaultPeriodicManHours.defaultValue) {
      return AHStyle.COLOR_ERROR;
    } else {
      return _categoryColorBasedOnShowHide;
    }
  }

  Color get _frequentLabelColor {
    if (isActiveCraneCategory &&
        _craneCategoryDefaultFrequentManHours.value ==
            _craneCategoryDefaultFrequentManHours.defaultValue) {
      return AHStyle.COLOR_ERROR;
    } else {
      return _categoryColorBasedOnShowHide;
    }
  }

  M2ObjectWrapperForControllers<String> _craneCategoryName;
  M2ObjectWrapperForControllers<double> _craneCategoryDefaultPeriodicManHours;
  M2ObjectWrapperForControllers<double> _craneCategoryDefaultFrequentManHours;

  // Constructor
  AQI_CraneCategorySettingsView(
      this.craneCategoryID, this._tellParentThisWidgetHasChanged,
      {Key key})
      : super(key: key) {
    _craneCategoryName =
        AQI_CraneCategoriesController.getCraneCategoryNameWrapper(
            craneCategoryID);
    _craneCategoryDefaultPeriodicManHours =
        AQI_CraneCategoriesController.getCraneCategoryDefaultManHoursWrapper(
            craneCategoryID, InspectionFrequency.PERIODIC);
    _craneCategoryDefaultFrequentManHours =
        AQI_CraneCategoriesController.getCraneCategoryDefaultManHoursWrapper(
            craneCategoryID, InspectionFrequency.FREQUENT);
  }

  // Builder
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 1.5 * AHStyle.lineHeight,
                width: 0.825 * AHStyle.internalPageWidth,
                child: AHTextField.fromTextWrapper(
                  //focusNode: nameFocusNode,
                  source: _craneCategoryName,
                  onSubmitted: () {
                    _tellParentThisWidgetHasChanged();
                  },
                  labelText: "Category Name",
                  hintText: "Category Name",
                  nonDefaultValueColor: _categoryNameTextColor,
                  defaultValueColor: _categoryNameHintColor,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: 1.5 * AHStyle.lineHeight,
                width: 0.175 * AHStyle.internalPageWidth,
                child: Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      bool thisCategoryIsActive =
                          AQI_CraneCategoriesController.isCraneCategoryActive(
                              craneCategoryID);
                      AQI_CraneCategoriesController
                          .setCraneCategoryToActiveOrLegacy(
                              craneCategoryID, !thisCategoryIsActive);
                      _tellParentThisWidgetHasChanged();
                    },
                    icon: getShowHideIcon(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 0.75 * AHStyle.lineHeight,
          padding: EdgeInsets.only(left: 0.0 * AHStyle.lineHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  AHBodyText(
                    "Periodic ",
                    color: _periodicLabelColor,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 0.15 * AHStyle.internalPageWidth,
                    height: 0.75 * AHStyle.lineHeight,
                    child: AHNumericField.fromDoubleWrapper(
                      source: _craneCategoryDefaultPeriodicManHours,
                      onSubmitted: () {
                        _tellParentThisWidgetHasChanged();
                      },
                      decimalCount: 2,
                      nonDefaultValueColor: _periodicLabelColor,
                      defaultValueColor: _periodicLabelColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  AHBodyText(
                    "Frequent ",
                    color: _frequentLabelColor,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 0.15 * AHStyle.internalPageWidth,
                    height: 0.75 * AHStyle.lineHeight,
                    child: AHNumericField.fromDoubleWrapper(
                      source: _craneCategoryDefaultFrequentManHours,
                      shouldChangeColorIfNotEqualToDefaultValue: false,
                      onSubmitted: () {
                        _tellParentThisWidgetHasChanged();
                      },
                      decimalCount: 2,
                      nonDefaultValueColor: _frequentLabelColor,
                      defaultValueColor: _frequentLabelColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Icon getShowHideIcon() {
    if (isActiveCraneCategory == true) {
      return Icon(
        Icons.visibility,
        color: _categoryColorBasedOnShowHide,
      );
    } else {
      return Icon(
        Icons.visibility_off,
        color: _categoryColorBasedOnShowHide,
      );
    }
  }
}
