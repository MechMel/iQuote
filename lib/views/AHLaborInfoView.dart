import 'package:axiom_hoist_quote_calculator/M2/M2FlutterUtilities.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AQI_QuoteController.dart';
import 'package:axiom_hoist_quote_calculator/models/AQI_Quote.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/UI/custom_widgets/M2UIBuilders.dart';
import 'package:axiom_hoist_quote_calculator/models/AHTask.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AQI_InputFields.dart';

class AHLaborInfoView extends StatelessWidget {
  final void Function() _tellParentThatLaborInfoHasChanged;
  final AQI_QuoteController _quote;

  AHLaborInfoView(this._quote, this._tellParentThatLaborInfoHasChanged,
      {Key key})
      : super(key: key);

  void onSubmitted(String text) {
    applyLaborInfoChanges();
  }

  void applyLaborInfoChanges() {
    if (_tellParentThatLaborInfoHasChanged != null) {
      _tellParentThatLaborInfoHasChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuoteInfoArea(context),
      ],
    );
  }

  // Area Builders
  Widget _buildQuoteInfoArea(BuildContext context) {
    double numericFieldHeight = 0.85 * AHStyle.lineHeight;
    double sec1Width = 0.1 * AHStyle.internalPageWidth;
    double sec2Width = 0.13 * AHStyle.internalPageWidth;
    //double sec3Width = 0.0 * AHStyle.internalPageWidth;
    double sec4Width = 0.155 * AHStyle.internalPageWidth;
    double sec5Width = 0.269 * AHStyle.internalPageWidth;
    EdgeInsetsGeometry padding =
        EdgeInsets.only(left: 0.014 * AHStyle.internalPageWidth);

    Column laborArea = M2UIBuilders.buildDisplayArea(
      title: "Quote #${_quote.quoteNumber[_quote.frequency.value]}",
      children: List(),
    );

    // Add the frequency buttons
    laborArea.children.add(getFrequencyButtons());

    // Spacer
    laborArea.children.add(
      Column(
        children: <Widget>[
          Container(
            height: 0.35 * AHStyle.lineHeight,
          ),
          Container(
            width: 0.85 * AHStyle.internalPageWidth,
            height: 0.1,
            child: OutlineButton(
              onPressed: () {},
            ),
          ),
          Container(
            height: 0.35 * AHStyle.lineHeight,
          ),
        ],
      ),
    );

    // Create a TaskView for each of this estimation's tasks
    for (AHTask task in _quote.getTasks()) {
      laborArea.children.add(
        Container(
          height: 2.0 * AHStyle.lineHeight,
          width: AHStyle.internalPageWidth,
          child: Row(
            children: [
              M2UIBuilders.buildIncDecButtons2(
                context: context,
                incrementValue: () {
                  task.quantity++;
                  applyLaborInfoChanges();
                },
                decrementValue: () {
                  if (task.quantity > 0) {
                    task.quantity--;
                    applyLaborInfoChanges();
                  }
                },
              ),
              Container(
                height: numericFieldHeight,
                width: sec2Width,
                padding: padding,
                alignment: Alignment.center,
                child: AHNumericField(
                  getValue: () {
                    return task.quantity;
                  },
                  setValue: (value) {
                    task.quantity = value.toInt();
                  },
                  onSubmitted: () {
                    applyLaborInfoChanges();
                  },
                  defaultValue: 0,
                  decimalCount: 0,
                ),
              ),
              Expanded(
                child: Container(
                  padding: padding,
                  child: AHBodyText(task.taskName),
                ),
              ),
              Container(
                height: numericFieldHeight,
                padding: padding,
                width: sec4Width,
                child: AHNumericField(
                  getValue: () {
                    return task.getPerUnitManHours(_quote.frequency.value);
                  },
                  setValue: (value) {
                    task.setPerUnitManHours(
                        _quote.frequency.value, value.toDouble());
                  },
                  defaultValue:
                      task.getDefaultPerUnitManHours(_quote.frequency.value),
                  onSubmitted: () {
                    applyLaborInfoChanges();
                  },
                  decimalCount: 2,
                ),
              ),
              Container(
                width: sec5Width,
                padding: padding,
                child: AHBodyText("= " +
                    M2FlutterUtilities.getPrintableNum(
                        task.getTotalManHours(_quote.frequency.value), 2) +
                    " hr"),
              ),
            ],
          ),
        ),
      );
    }

    // Labor Total
    laborArea.children.add(
      Container(
        height: 1.5 * AHStyle.lineHeight,
        width: AHStyle.internalPageWidth,
        child: Row(
          children: [
            Container(
              width: sec1Width + sec2Width,
              padding: padding,
              child: AHBodyText(
                M2FlutterUtilities.getPrintableNum(_quote.totalManHours, 0),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Container(
                padding: padding,
                child: AHBodyText(
                  "Hours at",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              padding: padding,
              child: AHBodyText("\$"),
            ),
            Container(
              height: numericFieldHeight,
              padding: padding,
              width: sec4Width,
              child: AHNumericField.fromDoubleWrapper(
                source: _quote.hourlyRate,
                onSubmitted: () {
                  applyLaborInfoChanges();
                },
                decimalCount: 2,
              ),
            ),
            Container(
              width: sec5Width,
              padding: padding,
              child: AHBodyText("= \$ " +
                  M2FlutterUtilities.getPrintableNum(_quote.totalLaborCost, 0)),
            ),
          ],
        ),
      ),
    );

    // Spacer
    laborArea.children.add(
      Column(
        children: <Widget>[
          Container(
            height: 0.35 * AHStyle.lineHeight,
          ),
          Container(
            width: 0.85 * AHStyle.internalPageWidth,
            height: 0.1,
            child: OutlineButton(
              onPressed: () {},
            ),
          ),
          Container(
            height: 0.35 * AHStyle.lineHeight,
          ),
        ],
      ),
    );

    // Man lift quantity
    laborArea.children.add(
      Container(
        height: 2.0 * AHStyle.lineHeight,
        width: AHStyle.internalPageWidth,
        child: Row(
          children: [
            M2UIBuilders.buildIncDecButtons2(
              context: context,
              incrementValue: () {
                _quote.manLifts.quantity++;
                applyLaborInfoChanges();
              },
              decrementValue: () {
                if (_quote.manLifts.quantity > 0) {
                  _quote.manLifts.quantity--;
                  applyLaborInfoChanges();
                }
              },
            ),
            Container(
              height: numericFieldHeight,
              width: sec2Width,
              padding: padding,
              alignment: Alignment.center,
              child: AHNumericField.fromIntWrapper(
                source: _quote.manLifts.quantityWrapper,
                onSubmitted: () {
                  applyLaborInfoChanges();
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: padding,
                child: AHBodyText(
                  "Manlifts",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              padding: padding,
              child: AHBodyText("\$"),
            ),
            Container(
              padding: padding,
              height: numericFieldHeight,
              width: sec4Width,
              child: AHNumericField.fromDoubleWrapper(
                source: _quote.manLifts.rateWrapper,
                onSubmitted: () {
                  applyLaborInfoChanges();
                },
                decimalCount: 2,
              ),
            ),
            Container(
              width: sec5Width,
              padding: padding,
              child: AHBodyText("= \$ " +
                  M2FlutterUtilities.getPrintableNum(
                      _quote.totalScissorLiftCost, 2)),
            ),
          ],
        ),
      ),
    );

    // Trasnportation
    laborArea.children.add(
      Container(
        height: 1.5 * AHStyle.lineHeight,
        width: AHStyle.internalPageWidth,
        child: Row(
          children: [
            Container(
              width: sec1Width,
            ),
            Container(
              height: numericFieldHeight,
              width: sec2Width,
              padding: padding,
              alignment: Alignment.center,
              child: AHNumericField.fromDoubleWrapper(
                source: _quote.transportaion.quantityWrapper,
                onSubmitted: () {
                  applyLaborInfoChanges();
                },
                decimalCount: 1,
              ),
            ),
            Expanded(
              child: Container(
                padding: padding,
                child: AHBodyText(
                  "Total Miles",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              padding: padding,
              child: AHBodyText("\$"),
            ),
            Container(
              padding: padding,
              height: numericFieldHeight,
              width: sec4Width,
              child: AHNumericField.fromDoubleWrapper(
                source: _quote.transportaion.rateWrapper,
                onSubmitted: () {
                  applyLaborInfoChanges();
                },
                decimalCount: 2,
              ),
            ),
            Container(
              width: sec5Width,
              padding: padding,
              child: AHBodyText("= \$ " +
                  M2FlutterUtilities.getPrintableNum(
                      _quote.totalTransportationCost, 2)),
            ),
          ],
        ),
      ),
    );

    // Fees
    laborArea.children.add(
      Container(
        height: 1.25 * AHStyle.lineHeight,
        width: AHStyle.internalPageWidth,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: padding,
                child: AHBodyText(
                  "Fees",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Container(
              padding: padding,
              child: AHBodyText("= \$"),
            ),
            Container(
              height: numericFieldHeight,
              width: 0.19 * AHStyle.internalPageWidth,
              padding: padding,
              child: AHNumericField.fromDoubleWrapper(
                source: _quote.fees,
                onSubmitted: () {
                  applyLaborInfoChanges();
                },
                decimalCount: 2,
              ),
            ),
          ],
        ),
      ),
    );

    // Discounts
    laborArea.children.add(
      Container(
        height: 1.1 * AHStyle.lineHeight,
        width: AHStyle.internalPageWidth,
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: AHBodyText(
                  "Discounts",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Container(
              padding: padding,
              child: AHBodyText("= \$"),
            ),
            Container(
              height: numericFieldHeight,
              width: 0.19 * AHStyle.internalPageWidth,
              padding: padding,
              child: AHNumericField.fromDoubleWrapper(
                source: _quote.discounts,
                onSubmitted: () {
                  applyLaborInfoChanges();
                },
                decimalCount: 2,
              ),
            ),
          ],
        ),
      ),
    );

    // Show Cost Breakdown
    laborArea.children.add(
      Container(
        height: 1.1 * AHStyle.lineHeight,
        width: AHStyle.internalPageWidth,
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: AHBodyText(
                  "Show Cost Breakdown",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Container(
              padding: padding,
              height: numericFieldHeight,
              child: Checkbox(
                activeColor: AHStyle.COLOR_PRIMARY,
                checkColor: AHStyle.COLOR_BACKGROUND,
                tristate: false,
                value: _quote.shouldShowTaskBreakDownInExport.value,
                onChanged: (value) {
                  _quote.shouldShowTaskBreakDownInExport.value = value;
                  applyLaborInfoChanges();
                },
              ),
            ),
            Container(
              width: 0.038 * AHStyle.internalPageWidth,
            ),
          ],
        ),
      ),
    );

    // Spacer
    laborArea.children.add(
      Column(
        children: <Widget>[
          Container(
            height: 0.35 * AHStyle.lineHeight,
          ),
          Container(
            width: 0.85 * AHStyle.internalPageWidth,
            height: 0.1,
            child: OutlineButton(
              onPressed: () {},
            ),
          ),
          Container(
            height: 0.35 * AHStyle.lineHeight,
          ),
        ],
      ),
    );

    // Total Estimated Cost
    laborArea.children.add(
      Container(
        height: AHStyle.lineHeight,
        alignment: Alignment.center,
        child: AHHeadlineText(
          "Total Estimated Cost = \$ " +
              M2FlutterUtilities.getPrintableNum(_quote.totalCost, 2),
          textAlign: TextAlign.center,
        ),
      ),
    );

    // Spacer
    laborArea.children.add(
      Container(
        height: 0.2 * AHStyle.lineHeight,
      ),
    );

    return laborArea;
  }

  // Create the frequency buttons
  Widget getFrequencyButtons() {
    List<Widget> frequencyButtons = List();
    if (_quote.frequency.value == InspectionFrequency.PERIODIC) {
      frequencyButtons.add(
        FlatButton(
          color: AHStyle.COLOR_PRIMARY,
          onPressed: () {},
          child: AHBodyText(
            "Periodic",
            color: AHStyle.COLOR_BACKGROUND,
          ),
        ),
      );
      frequencyButtons.add(
        AHBodyText("------", color: AHStyle.COLOR_HINT),
      );
      frequencyButtons.add(
        OutlineButton(
          borderSide: BorderSide(color: AHStyle.COLOR_PRIMARY, width: 1.5),
          color: AHStyle.COLOR_PRIMARY,
          onPressed: () {
            _quote.frequency.value = InspectionFrequency.FREQUENT;
            applyLaborInfoChanges();
          },
          child: AHBodyText(
            "Frequent",
            color: AHStyle.COLOR_PRIMARY,
          ),
        ),
      );
    } else if (_quote.frequency.value == InspectionFrequency.FREQUENT) {
      frequencyButtons.add(
        OutlineButton(
          borderSide: BorderSide(color: AHStyle.COLOR_PRIMARY, width: 1.5),
          color: AHStyle.COLOR_PRIMARY,
          onPressed: () {
            _quote.frequency.value = InspectionFrequency.PERIODIC;
            applyLaborInfoChanges();
          },
          child: AHBodyText(
            "Periodic",
            color: AHStyle.COLOR_PRIMARY,
          ),
        ),
      );
      frequencyButtons.add(
        AHBodyText("------", color: AHStyle.COLOR_HINT),
      );
      frequencyButtons.add(
        FlatButton(
          color: AHStyle.COLOR_PRIMARY,
          onPressed: () {},
          child: AHBodyText(
            "Frequent",
            color: AHStyle.COLOR_BACKGROUND,
          ),
        ),
      );
    }

    return Container(
      width: 0.77 * AHStyle.internalPageWidth,
      height: 1.25 * AHStyle.lineHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: frequencyButtons,
      ),
    );
  }
}
