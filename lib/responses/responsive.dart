import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'dimension.dart';


class responsive_layout extends StatefulWidget {
  final Widget Android;
  final Widget Web;

  const responsive_layout({Key? key, required this.Android, required this.Web}) : super(key: key);

  @override
  State<responsive_layout> createState() => _responsive_layoutState();
}

class _responsive_layoutState extends State<responsive_layout>
{

  @override
  void initState() {
    super.initState();
    add_data();
  }

  add_data() async
  {
    UserProvider userProvider=Provider.of(context,listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constrainst)
    {
      if(constrainst.maxWidth<dimension)
        {
          return widget.Android;
        }
      else
        {
          return widget.Web;
        }
    });
  }
}
