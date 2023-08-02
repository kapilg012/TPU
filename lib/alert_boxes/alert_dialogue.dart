import 'package:flutter/material.dart';
import 'package:teen_patti_utility/player_model.dart';

import '../common_widgets.dart';
import '../dimen.dart';

class AlertDialogueScreen extends StatefulWidget {
  bool isFromReset;
  List<Player>? listOfPlayer;
  bool isFromTwoWinner;

  AlertDialogueScreen(
      this.listOfPlayer, this.isFromReset, this.isFromTwoWinner);

  @override
  _AlertDialogueScreenState createState() => _AlertDialogueScreenState();
}

class _AlertDialogueScreenState extends State<AlertDialogueScreen> {
  @override
  Widget build(BuildContext context) {
    return getDeleteCard;
  }

  get getDeleteCard => Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.only(
            left: Spacing.space10,
            right: Spacing.space10,
            top: Spacing.large,
            bottom: Spacing.large),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            spacingVerticalSpace10,
            const Text(
              "Alert",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            spacingVerticalSpace10,
            Text(
              widget.isFromReset
                  ? "Do You Want to reset the Game ?"
                  : (widget.isFromTwoWinner)
                      ? "Are you sure there are multiple winners in this game ?"
                      : "Are you sure he is the winner ?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            spacingVerticalSpace10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getCancelButton,
                const SizedBox(
                  width: Spacing.xxSmall,
                ),
                getWinnerButton,
              ],
            ),
          ],
        ),
      );

  get getCancelButton => Expanded(
        child: InkWell(
          onTap: () async {
            Navigator.of(context).pop(false);
          },
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(RadiusConst.largeBox25)),
            child: const Center(
              child: Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      );

  get getWinnerButton => Expanded(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(RadiusConst.largeBox25)),
            child: Center(
              child: Text(
                (widget.isFromReset) ? "Reset" : "Yes !!!",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
}
