///MODULE: Dynamic Table Widget
///git
///Created by Aditi Salaria on <<unknown date>>
///
///ABOUT:
///[DynamicTableWidget] class for displaying the dynamic table widgets in the web page.
///
///
///MODIFICATIONS:
/// 28 Mar 2023 - Modified the table data row to display the data cell to display the
/// status with status sty
/// 29 March 2023 - To fetch the old implementation using only values check the commit ID -  4a5ae93

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sole_admin_app/constants/color_constants.dart';
import 'package:sole_admin_app/constants/font_size.dart';
import 'package:sole_admin_app/core/widgets/common/onhover.dart';

import '../../../constants/text_constants.dart';
import '../../../utils/responsive.dart';

class DynamicTableWidget extends StatefulWidget {
  final List<String> headings;
  final List<DataRow> values;
  final bool showcheckbox;

  const DynamicTableWidget({
    super.key,
    required this.showcheckbox,
    required this.headings,
    required this.values,
  });
  @override
  State<DynamicTableWidget> createState() => _DynamicTableWidgetState();
}

class _DynamicTableWidgetState extends State<DynamicTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            dividerTheme: const DividerThemeData(
                color: Colors.transparent, thickness: 0.0)),
        child: SingleChildScrollView(
            scrollDirection:
                //  Axis.horizontal,
                (Responsive.isMobile(context) || Responsive.isTablet(context))
                    ? Axis.horizontal
                    : Axis.vertical,
            child: DataTable(
                onSelectAll: (value) {
                  print(value);
                },
                showCheckboxColumn: widget.showcheckbox,
                headingTextStyle: const TextStyle(
                  fontSize: 10,
                ),
                dividerThickness: 0.0,
                horizontalMargin: 10,
                columnSpacing: 10,
                columns: widget.headings

                    //.map is used for list
                    .map(
                      (e) => DataColumn(
                        label: SizedBox(
                            width: 100,
                            child: Text(
                              e,
                              style: const TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    )
                    .toList(),
                rows: List.generate(
                  widget.values.length,
                  (index) => widget.values[index],
                ))));
  }
}

DataRow buildDataRow({
  void Function()? onTapViewAll,
  required List<String> values,
  required List<String> keys,
  required List<dynamic> rowDataList,
  bool showViewButton = true,
  bool isIconClickable = false,
}) {
  log('Table Data :: $rowDataList');

  return DataRow(cells: [
    ///... spreadoperator spread operator (...) is used to
    /// provide a way to assign values to Collections

    ...rowDataList.map(((e) {
      log("Map Object :: $e");

      //If value contains any image path then it will display
      //TODO:: Need to modify this condition, as API will have the image URL and not SVG
      return e.value.toString().contains(".svg")

          //"isIconClickable" has the value true then it will display the delete icon,
          //and if not then it will not display this icon.
          ? isIconClickable
              ? DataCell(OnHover(builder: (isHovered) {
                  return InkWell(
                      onTap: () {
                        log("Icon Pressed");
                      },
                      child: SizedBox(
                          width: 30, child: SvgPicture.asset(e.value)));
                }))
              : DataCell(OnHover(builder: (isHovered) {
                  return SizedBox(width: 30, child: SvgPicture.asset(e.value));
                }))

          //If the API contains "workflow_state" parameter in response then as
          //per ERP we have to give priority to this parameter only and if not
          //then it will look for the "status" parameter in API response

          : e.key == "STATUS"
              ? DataCell(OnHover(builder: (isHovered) {
                  return Tooltip(
                      message: e.value,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: e.value == "Active"
                                ? ColorConstants.greenColor
                                : ColorConstants.yellowColorBg),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            e.value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: e.value == "Active"
                                    ? ColorConstants.bgGreenColor
                                    : ColorConstants.yellowColor,
                                fontSize: 21),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ));
                }))

              //Condition for "workflow_state" parameter

              : e.key == "workflow_state"
                  ? DataCell(OnHover(builder: (isHovered) {
                      return Tooltip(
                          message: e.value,
                          child: Text(
                            e.value,
                            style: const TextStyle(
                                color: ColorConstants.greenColor, fontSize: 10),
                            textAlign: TextAlign.center,
                          ));
                    }))

                  //condition for "status" parameter

                  : e.key == "status"
                      ? DataCell(OnHover(builder: (isHovered) {
                          return Tooltip(
                              message: e.value,
                              child: Container(
                                  width: 80,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      color: ColorConstants.bgGreenColor
                                          .withOpacity(0.3)),
                                  child: Text(
                                    e.value,
                                    style: const TextStyle(
                                        color:
                                            ColorConstants.greenTextStatusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )));
                        }))

                      //else it will dislay the default data

                      : DataCell(OnHover(builder: (isHovered) {
                          return SizedBox(
                              width: 100,
                              child: Tooltip(
                                  message: e.value.toString(),
                                  child: Text(
                                    e.value.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  )));
                        }));
    })).toList(),

    //If needs to show the "View" button to open the detailed view of the report/data
    //This will display at the last of the table
    if (showViewButton)
      DataCell(Row(children: [
        OnHover(builder: (isHovered) {
          return SizedBox(
              width: 100,
              child: TextButton(
                onPressed: onTapViewAll,
                child: Text(TextConstants.viewText,
                    style: const TextStyle(color: Colors.blue)),
              ));
        }),
      ]))

    // ...values
    //     .map(((e) => e.contains(".svg")
    //         ? isIconClickable
    //             ? DataCell(OnHover(builder: (isHovered) {
    //                 return InkWell(
    //                     onTap: () {
    //                       log("Icon Pressed");
    //                     },
    //                     child: SizedBox(
    //                         width: 30, child: SvgPicture.asset(e)));
    //               }))
    //             : DataCell(OnHover(builder: (isHovered) {
    //                 return SizedBox(width: 30, child: SvgPicture.asset(e));
    //               }))
    //         : DataCell(OnHover(builder: (isHovered) {
    //             return Tooltip(
    //                 message: e,
    //                 child: Text(
    //                   e,
    //                   style:
    //                       TextStyle(fontSize: FontSize.tableContentTxtSize),
    //                   textAlign: TextAlign.center,
    //                 ));
    //           }))))
    //     .toList(),
    // if (showViewButton)
    //   DataCell(Row(children: [
    //     OnHover(builder: (isHovered) {
    //       return TextButton(
    //         onPressed: onTapViewAll,
    //         child: Text(TextConstants.viewText,
    //             style: const TextStyle(color: Colors.blue)),
    //       );
    //     }),
    //   ]))
  ]);
}
