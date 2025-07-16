import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/pet/petDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/petService.dart';

import 'deadPet.dart';
class Managepet extends StatefulWidget {
  final PetDTO pd;
  final VoidCallback onRefresh;
  const Managepet({super.key, required this.pd, required this.onRefresh});

  @override
  State<Managepet> createState() => _ManagepetState();
}

class _ManagepetState extends State<Managepet> {
  PetService ps = PetService();
  CoinService cs = CoinService();
  MyNotification mn = MyNotification();
  bool load=false;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
        inAsyncCall: load,
        child: FutureBuilder(
        future: ps.getImage(widget.pd.species, widget.pd.subLevel),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.network(snapshot.data),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return Deadpet();
                              }));
                        }, icon: Icon(Icons.pets)),
                      ),
                      //차트
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text("포만감"),
                              SizedBox(height: 5),
                              Container(
                                height: 100-widget.pd.hunger*1,
                                width: fullWidth*0.1,
                                color: Colors.black12,
                              ),
                              Container(
                                height: widget.pd.hunger*1,
                                width: fullWidth*0.1,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 5),
                              Text(widget.pd.hunger.toString()),
                            ],
                          ),
                          const SizedBox(width: 25),
                          Column(
                            children: [
                              Text("체력"),
                              SizedBox(height: 5),
                              Container(
                                height: 100-widget.pd.fatigue*1,
                                width: fullWidth*0.1,
                                color: Colors.black12,
                              ),
                              Container(
                                height: widget.pd.fatigue*1,
                                width: fullWidth*0.1,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 5),
                              Text(widget.pd.fatigue.toString()),
                            ],
                          ),
                          const SizedBox(width: 25),
                          Column(
                            children: [
                              Text("행복"),
                              SizedBox(height: 5),
                              Container(
                                height: 100-widget.pd.happy*1,
                                width: fullWidth*0.1,
                                color: Colors.black12,
                              ),
                              Container(
                                height: widget.pd.happy*1,
                                width: fullWidth*0.1,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 5),
                              Text(widget.pd.happy.toString()),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text("LEVEL : ${widget.pd.level}"),
                      Text("EXP : ${widget.pd.subLevel}"),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  onPressed: ()async{
              
                                    setState(() {load=true;});
                                    int coin = await cs.getCoin(user!.uid);
              
                                    if(coin <3){
                                      mn.SnackbarBasic(context, "코인이 부족합니다! (펫 관리 1회 = 3코인)");
                                      setState(() {load=false;});
                                      return;
                                    }
                                    await cs.changeCoin(coin-3, user!.uid);
                                    await ps.feed(user!.uid, widget.pd, context);
                                    await ps.getExp(user!.uid, widget.pd, 0, context);
                                    widget.onRefresh();
                                    setState(() {load=false;});
                                  },
                                  icon: const Icon(Icons.fastfood, size: 40),
                              ),
                              const Text("식사")
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              IconButton(
                                onPressed: ()async{
                                  setState(() {load=true;});
                                  int coin = await cs.getCoin(user!.uid);

                                  if(coin <3){
                                    mn.SnackbarBasic(context, "코인이 부족합니다! (펫 관리 1회 = 3코인)");
                                    setState(() {load=false;});
                                    return;
                                  }
                                  await cs.changeCoin(coin-3, user!.uid);
                                  await ps.sleep(user!.uid, widget.pd, context);
                                  await ps.getExp(user!.uid, widget.pd, 1, context);

                                  widget.onRefresh();
                                  setState(() {load=false;});
                                },
                                icon: const Icon(Icons.bed, size: 40),
                              ),
                              const Text("수면")
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              IconButton(
                                onPressed: ()async{
                                  setState(() {load=true;});
                                  int coin = await cs.getCoin(user!.uid);

                                  if(coin <3){
                                    mn.SnackbarBasic(context, "코인이 부족합니다! (펫 관리 1회 = 3코인)");
                                    setState(() {load=false;});
                                    return;
                                  }
                                  await cs.changeCoin(coin-3, user!.uid);
                                  await ps.play(user!.uid, widget.pd, context);
                                  await ps.getExp(user!.uid, widget.pd, 2, context);

                                  widget.onRefresh();
                                  setState(() {load=false;});
                                },
                                icon: const Icon(Icons.toys, size: 40),
                              ),
                              const Text("놀이")
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
          return const Text("loading...");


        }));
  }
}
