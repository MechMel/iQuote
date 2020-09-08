/*import 'dart:convert';
import 'package:axiom_hoist_quote_calculator/PDF/AHPDFExporter.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHAppController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHDiskController.dart';
import 'package:axiom_hoist_quote_calculator/controllers/AHEmailController.dart';
import 'package:axiom_hoist_quote_calculator/models/AHSettings.dart';
import 'package:flutter/material.dart';
import 'package:axiom_hoist_quote_calculator/models/AHEstimation.dart';
import 'package:axiom_hoist_quote_calculator/models/AHTask.dart';
import 'package:axiom_hoist_quote_calculator/views/AHStyle.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomWidgets.dart';
import 'package:axiom_hoist_quote_calculator/views/AHTaskView.dart';
import 'package:axiom_hoist_quote_calculator/views/AHCustomerInfoView.dart';

class AHEstimationView extends StatefulWidget {
  final AHEstimation estimation;

  AHEstimationView(this.estimation, {Key key}) : super(key: key);

  @override
  _AHEstimationViewState createState() => _AHEstimationViewState();
}

class _AHEstimationViewState extends State<AHEstimationView> {
  TextEditingController hourlyRateTextFieldController = TextEditingController(text: "0");
  TextEditingController roundTripDistanceFieldController = TextEditingController(text: "0");
  TextEditingController perMileCostFieldController = TextEditingController(text: "0");

  static AHEstimation loadEstimation(String estimationFileName) {
    String jsonText = AHDiskController.loadFileAsString(estimationFileName);
    if (jsonText != null) {
      Map<String, dynamic> decodedJson = jsonDecode(jsonText);
      return AHEstimation.fromDecodedJson(decodedJson);
    } else {
      return AHEstimation();
    }
  }

  static void saveEstimation(AHEstimation estimation) {
    AHAppController.saveEstimation(estimation);
  }

  void updateState() {
    saveEstimation(widget.estimation);
    setState(() {});
  }

  void setHourlyRateFromText(String newHourlyRateText) {
    if (newHourlyRateText != "") {
      widget.estimation.hourlyRate = double.parse(newHourlyRateText);
    } else {
      widget.estimation.hourlyRate = AHEstimation.DEFAULT_HOURLY_RATE;
    }
    updateState();
  }

  InputBorder getHourlyRateBorder() {
    if (widget.estimation.hourlyRate == AHEstimation.DEFAULT_HOURLY_RATE) {
      return AHStyle.DEFAULT_VALUE_BORDER;
    } else {
      return AHStyle.CUSTOM_VALUE_BORDER;
    }
  }

  void setRoundTripDistanceFromText(String newRoundTripDistanceText) {
    if (newRoundTripDistanceText != "") {
      widget.estimation.roundTripDistance = double.parse(newRoundTripDistanceText);
    } else {
      widget.estimation.roundTripDistance = 0;
    }
    updateState();
  }

  InputBorder getRondTripDistanceBorder() {
    if (widget.estimation.roundTripDistance == 0) {
      return AHStyle.DEFAULT_VALUE_BORDER;
    } else {
      return AHStyle.CUSTOM_VALUE_BORDER;
    }
  }

  void setPerMileCostFromText(String newPerMileCostText) {
    if (newPerMileCostText != "") {
      widget.estimation.perMileCost = double.parse(newPerMileCostText);
    } else {
      widget.estimation.perMileCost = AHEstimation.DEFAULT_PER_MILE_COST;
    }
    updateState();
  }

  InputBorder getPerMileCostBorder() {
    if (widget.estimation.perMileCost == AHEstimation.DEFAULT_PER_MILE_COST) {
      return AHStyle.DEFAULT_VALUE_BORDER;
    } else {
      return AHStyle.CUSTOM_VALUE_BORDER;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.estimation.hourlyRate == AHEstimation.DEFAULT_HOURLY_RATE) {
      hourlyRateTextFieldController.text = "";
    } else {
      hourlyRateTextFieldController.text = widget.estimation.hourlyRate.toString();
    }
    if (widget.estimation.roundTripDistance == 0) {
      roundTripDistanceFieldController.text = "";
    } else {
      roundTripDistanceFieldController.text = widget.estimation.roundTripDistance.toString();
    }
    if (widget.estimation.perMileCost == AHEstimation.DEFAULT_PER_MILE_COST) {
      perMileCostFieldController.text = "";
    } else {
      perMileCostFieldController.text = widget.estimation.perMileCost.toString();
    }

    return Column(
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 0.8,
          child: AHCostomerInfoView(widget.estimation.customerInfo, onSetState: updateState,),
        ),
        generateLabourEstimationArea(widget.estimation),
      ],
    );
  }

  // Create a Column of TaskViews for each of this estimation's tasks
  Widget generateLabourEstimationArea(AHEstimation estimation) {
    Column estimationInfoColumn = Column(children: <Widget>[]);

    // Add the labour area header
    estimationInfoColumn.children.add(AHHeader("Labour"));

    // Create a TaskView for each of this estimation's tasks
    for (AHTask task in estimation.tasks) {
      estimationInfoColumn.children.add(AHTaskView(task, onSetState: updateState,));
    }
    
    // Total hours
    estimationInfoColumn.children.add(
      Container(
        height: 1.25 * AHStyle.LINE_HEIGHT,
        child: Center(
          child: Row(
            children: <Widget>[
              // "Total hours" label
              Container(
                width: 0.64 * MediaQuery.of(context).size.width,
                child: AHBodyText("Total hours", textAlign: TextAlign.right,),
              ),
            
              // "=" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("="),
                ),
              ),
            
              // Spacer
              Container(
                width: .063 * MediaQuery.of(context).size.width,
              ),
            
              // Total Hours Label
              Container(
                height: AHStyle.LINE_HEIGHT / 1.25,
                width: .145 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText(
                    estimation.totalManHours.toString() + " hr",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
    
    // Hourly rate
    estimationInfoColumn.children.add(
      Container(
        height: 2 * AHStyle.LINE_HEIGHT,
        child: Center(
          child: Row(
            children: <Widget>[
              // "Hourly rate" label
              Container(
                width: 0.64 * MediaQuery.of(context).size.width,
                child: AHBodyText("Hourly rate", textAlign: TextAlign.right,),
              ),
            
              // "=" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("="),
                ),
              ),
            
              // "$" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("\$"),
                ),
              ),
            
              // Hourly Rate TextField
              Center(
                child: Container(
                  height: 1.5 * AHStyle.LINE_HEIGHT,
                  width: .175 * MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: AHTextField(
                          textAlign: TextAlign.center,
                          onSubmitted: setHourlyRateFromText,
                          controller: hourlyRateTextFieldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: getHourlyRateBorder(),
                            hintText: AHEstimation.DEFAULT_HOURLY_RATE.toString(), 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
    
    // Total labour cost
    estimationInfoColumn.children.add(
      Container(
        height: 1.25 * AHStyle.LINE_HEIGHT,
        child: Center(
          child: Row(
            children: <Widget>[
              // "Labour cost" label
              Container(
                width: 0.64 * MediaQuery.of(context).size.width,
                child: AHBodyText("Labour cost", textAlign: TextAlign.right,),
              ),
            
              // "=" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("="),
                ),
              ),
            
              // Spacer
              Container(
                width: .06 * MediaQuery.of(context).size.width,
              ),
            
              // Total Hours Label
              Container(
                height: AHStyle.LINE_HEIGHT / 1.25,
                width: .145 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText(
                    "\$" + estimation.totalLabourCost.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );

    // TODO: Seperate Transportation Costs into their own function
    // Add the transportation area header
    estimationInfoColumn.children.add(AHHeader("Transportation"));
    
    // Round trip distance cost
    estimationInfoColumn.children.add(
      Container(
        height: 2 * AHStyle.LINE_HEIGHT,
        child: Center(
          child: Row(
            children: <Widget>[
              // "Round trip distance" label
              Container(
                width: 0.64 * MediaQuery.of(context).size.width,
                child: AHBodyText("Round trip distance", textAlign: TextAlign.right,),
              ),
            
              // "=" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("="),
                ),
              ),
            
              // Round trip distance Label
              Center(
                child: Container(
                  height: 1.5 * AHStyle.LINE_HEIGHT,
                  width: .175 * MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: AHTextField(
                          textAlign: TextAlign.center,
                          onSubmitted: setRoundTripDistanceFromText,
                          controller: roundTripDistanceFieldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: getRondTripDistanceBorder(),
                            hintText: 0.0.toString(), 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
              // miles Label
              Container(
                width: .06 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("mi"),
                ),
              ),
            ],
          ),
        ),
      )
    );
    
    // Per-mile cost
    estimationInfoColumn.children.add(
      Container(
        height: 2 * AHStyle.LINE_HEIGHT,
        child: Center(
          child: Row(
            children: <Widget>[
              // "Per-mile cost" label
              Container(
                width: 0.64 * MediaQuery.of(context).size.width,
                child: AHBodyText("Per-mile cost", textAlign: TextAlign.right,),
              ),
            
              // "=" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("="),
                ),
              ),
            
              // "$" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("\$"),
                ),
              ),
            
              // Per-mile cost TextField
              Center(
                child: Container(
                  height: 1.5 * AHStyle.LINE_HEIGHT,
                  width: .175 * MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: AHTextField(
                          textAlign: TextAlign.center,
                          onSubmitted: setPerMileCostFromText,
                          controller: perMileCostFieldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: getPerMileCostBorder(),
                            hintText: AHEstimation.DEFAULT_PER_MILE_COST.toString(), 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
    
    // Transportation cost
    estimationInfoColumn.children.add(
      Container(
        height: 1.25 * AHStyle.LINE_HEIGHT,
        child: Center(
          child: Row(
            children: <Widget>[
              // "Transportation cost" label
              Container(
                width: 0.64 * MediaQuery.of(context).size.width,
                child: AHBodyText("Transportation cost", textAlign: TextAlign.right,),
              ),
            
              // "=" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("="),
                ),
              ),
            
              // Spacer
              Container(
                width: .06 * MediaQuery.of(context).size.width,
              ),
            
              // Transportation cost Label
              Container(
                height: AHStyle.LINE_HEIGHT / 1.25,
                width: .145 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText(
                    "\$" + estimation.totalTransportationCost.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
    

    // TODO: Seperate Total Cost into it's own function
    // Add the transportation area header
    estimationInfoColumn.children.add(AHHeader("Total"));
    // Total estimated cost
    estimationInfoColumn.children.add(
      Container(
        height: 1.25 * AHStyle.LINE_HEIGHT,
        child: Center(
          child: Row(
            children: <Widget>[
              // "Total estimated cost" label
              Container(
                width: 0.64 * MediaQuery.of(context).size.width,
                child: AHBodyText("Total estimated cost", textAlign: TextAlign.right,),
              ),
            
              // "=" Label
              Container(
                width: .045 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText("="),
                ),
              ),
            
              // Spacer
              Container(
                width: .06 * MediaQuery.of(context).size.width,
              ),
            
              // Total estimated cost Label
              Container(
                height: AHStyle.LINE_HEIGHT / 1.25,
                width: .145 * MediaQuery.of(context).size.width,
                child: Center(
                  child: AHBodyText(
                    "\$" + estimation.totalCost.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
    
    return estimationInfoColumn;
  }
}*/