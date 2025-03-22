import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/application/count_day/count_day_bloc.dart';
import 'package:hnotes/presentation/components/build_card_widget.dart';

class SelectDateWidget extends StatelessWidget {
  final ButtonStyle style = ElevatedButton.styleFrom(backgroundColor: btnColor);

  SelectDateWidget({super.key});

  Widget _selectDateText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future selectDate() async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1966),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        // Convert selected date to string for showing
        String selectedDate = picked.toString().split(" ")[0];

        await daysBloc.updateLoveStartDate(selectedDate);
      }
    }

    return buildCardWidget(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardTitle('Love Start Date'),
          Container(height: 20),
          Center(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  style: style,
                  onPressed: selectDate,
                  child: StreamBuilder(
                    stream: daysBloc.dayModel,
                    builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
                      String buttonPlaceholder = "Select Date";
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        late String? storedStartDate;
                        String? data = snapshot.data?.loveStartDate;
                        if (data == null || data.isEmpty) {
                          storedStartDate = buttonPlaceholder;
                        } else {
                          storedStartDate = data;
                        }
                        return _selectDateText(storedStartDate);
                      }
                      return _selectDateText(buttonPlaceholder);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
