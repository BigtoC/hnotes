import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/application/count_day/count_day_bloc.dart';
import 'package:hnotes/presentation/components/build_card_widget.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';
import 'package:hnotes/infrastructure/local_storage/theme/theme_repository.dart';
import 'package:hnotes/infrastructure/local_storage/start_day/start_day_repository.dart';


class SelectDateWidget extends StatelessWidget {
  final ButtonStyle style = ElevatedButton.styleFrom(
    primary: btnColor,
  );

  Widget _selectDateText(String text) {
    return new Text(text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Future _selectDate() async {
      DateTime? picked = await showDatePicker(
          context: context,
          initialDate: new DateTime.now(),
          firstDate: new DateTime(1966),
          lastDate: new DateTime.now());
      if (picked != null) {
        // Convert selected date to string for showing
        String _selectedDate = picked.toString().split(" ")[0];

        // Write the selected date to system
        StartDayRepository.saveStartDate(_selectedDate);
        await daysBloc.fetchLoveStartDate();
      }
    }

    return buildCardWidget(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            cardTitle('Love Start Date'),
            Container(
              height: 20,
            ),
            Center(
              child: new Column(
                children: <Widget>[
                  new ElevatedButton(
                    style: style,
                    onPressed: _selectDate,
                    child: StreamBuilder(
                        stream: daysBloc.dayModel,
                        builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
                          String buttonPlaceholder = "Select Date";
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                            String storedStartDate = snapshot.data?.loveStartDate == null
                                ? buttonPlaceholder
                                : snapshot.data!.loveStartDate;
                            return _selectDateText(storedStartDate);
                          }
                          return _selectDateText(buttonPlaceholder);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
