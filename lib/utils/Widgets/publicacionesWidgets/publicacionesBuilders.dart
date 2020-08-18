import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/models/AnuncioModel.dart';
import 'package:ragapp/models/userModel.dart';
import 'package:ragapp/utils/Widgets/publicacionesWidgets/likeButton.dart';
import 'package:ragapp/utils/Widgets/widgets.dart';

class CustomBuilders{
  Widgets _widgets = Widgets();

  Widget viewBuilder({@required userPhoto, userName, isEmpty, views, userId, context,usersID,index}){
    final publicaciones = Provider.of<List<Publicaciones>>(context);
    final user = Provider.of<List<User>>(context);

    return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                  text: '${formatDate(DateTime.parse(  publicaciones[index].publishedDate.toString()), ['d',' ','M',' ','yyyy'])} | ',
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Glenn Slab'
                  ),
                ),
                isEmpty == true ?
                TextSpan(
                  text: '${isEmpty == true ? 0 :  views.data.length} Views',
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Glenn Slab'
                  ),
                ) :
                TextSpan(
                  text: '${isEmpty == true ? 0 :  views.data.length} Views',
                  recognizer: new TapGestureRecognizer()..onTap = () => _widgets.showView(context: context, view: views, user: user, type: 'view',userPhoto: userPhoto, userName:userName, userId: usersID),
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Glenn Slab'
                  ),
                )
              ]
          ),
        )
    );
  }

  Widget likeBuilder({userRole, likeUsers,likeID, snapshot,like, index, context}){
    return LikeButton(
      size: 25,
      countPostion: CountPostion.right,
      likeBuilder: (bool isLiked){
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.grey[700],
          size: 25,
        );
      },
      user: userRole,
      likedUser: likeUsers,
      likeId: likeID,
      publicaciones: snapshot,
      isEmpty: like.data != null ? false : true,
      likeCount: like.data != null ? like.data.length : 0,
      isLiked: like.data != null ? likeUsers.contains(userRole[0].uid) : false,
      index: index,
      countBuilder: (int count, bool isLiked, String text) {
        var color = Colors.grey[400];
        Widget result;
        if (count == 0) {
          result = InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: (){
            },
            child: Container(
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              height: 20,
              width: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "0",
                style: TextStyle(color: Colors.grey[700],fontFamily: 'Glenn Slab'),
              ),
            ),
          );
        } else
          result = InkWell(
            borderRadius: BorderRadius.circular(2),
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              // _widgets.showView(context: context, view: snapshot, user: user, type: 'like', userPhoto: usersPhoto, userName: usersName, userId: usersID);
            },
            child: Container(
              padding: EdgeInsets.only(right: 15),

              alignment: Alignment.centerRight,
              width: 35,
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.grey[700],fontFamily: 'Glenn Slab'),
              ),
            ),
          );
        return result;
      },
    );
  }
}