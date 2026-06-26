import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//ToastMessages OSZTÁLY ELEJE ---------------------------------------------------------------------

class ToastMessages {
//OSZTÁLY VÁLTOZÓK ELEJE --------------------------------------------------------------------------

  //FToast osztályból példányosít (flutter_toast csomagból)
  static final FToast _fToastInstance = FToast();

//OSZTÁLY VÁLTOZÓK VÉGE ---------------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  //Inicializálás, ezt csak egyszer kell meghívni! (szintén a main.dart-ban)
  static void init(BuildContext context) {
    //elmenti a BuildContext-et hogy mindig tudjuk hogy a widget (ahol meghívjuk) hol helyezkedik el a widget tree-be!
    _fToastInstance.init(context);
  }

  static void showToastMessages(
    String message,
    double verticalPercentage,
    Color bgColor,
    IconData icon,
    Color iconColor,
    Duration duration,
    BuildContext context, {
    double? leftPercentage,
    double? rightPercentage,
    bool center = true,
  }) {
    //ez a metódus megjelenít egy testreszabható,
    //tetszőleges helyen elhelyezhető, minden platformon megjelenő toast üzenetet (ami a képernyő alján van általában)

    //ha nincs elhelyezve a widget tree-ben akkor null értékkel visszatér,
    //mert assertion error-t adna!
    if (!context.mounted) return;

    //meghíváskor is inicializáljuk mivel mi van ha a felhasználó a token-ével nem jelentkezett be újra (exception lenne!)
    final fToast = FToast();
    fToast.init(context);

    //hogy bárhol megjelenítsük ahoz tudnunk kell a képernyő méreteit
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    _fToastInstance.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: bgColor,
        ),
        child: Row(
          //egy sor widget-be jelenítjük meg a tartalmat, ami a legkevesebb helyet foglalja!
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 12.0),
            Text(message),
          ],
        ),
      ),
      toastDuration: duration, //tetszőleges időn keresztűl jelenik meg
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          //a képernyő magasságának egy megadott százalékáig tud megjelenni az üzenet (maximum 1.0-ig)
          bottom: screenHeight * verticalPercentage,
          //ha úgy van meghívva a toast hogy center = false,
          //akkor százalékosan meg lehet mondani hogy balra, illetve jobbra hol helyezkedjen el (pl.: sidebar.dart státusz frissítésekor!)
          left: center
              ? 0
              : (leftPercentage != null ? screenWidth * leftPercentage : null),
          right: center
              ? 0
              : (rightPercentage != null
                  ? screenWidth * rightPercentage
                  : null),
          //különben pedig a bottom százaléktól függően középre igazítva fog megjelenni!
          child: center ? Center(child: child) : child,
        );
      },
    );
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------
}

//ToastMessages OSZTÁLY VÉGE ----------------------------------------------------------------------
