import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_base/config/data_config.dart';
import 'dart:math' as math;

import 'package:flutter_base/utils/utils.dart';

class BookPageView extends StatefulWidget {

  @override
  _BookPageViewState createState() => _BookPageViewState();
}

class _BookPageViewState extends State<BookPageView> with SingleTickerProviderStateMixin {
  String style = BookPageViewPainter.STYLE_BOTTOM_RIGHT;

  Offset a,f,g,e,h,c,j,b,k,d,i, temp;
  Size size = Size(DataConfig.appSize.width, DataConfig.appSize.height);

  Animation<double> animation;
  AnimationController controller;

  double value = 1.0;

  bool nextBook = true;

  Offset nextOffset;

  String text = "孤星走上岳阳楼的二层，坐在靠窗的座位，把宝刃“飞雪刀”挂在腰际；他倒满一杯烈酒，仰头灌下，望着窗外运河内倒映的明月，眼睛有些湿润。　　三年，若曦去世已经三年了。　　三年前，为报父母之仇，他闯入威震武林的林家堡，连过三十六关，亲手割掉了林天的头颅，祭奠在父母的坟前；此站，亦是他的成名之战，让他在武林中地位飙升，被推崇为武林第一高手。　　可是，那又如何，即便是武林第一高手，难道能使死人复活，能使时间逆转？　　自从若曦去世，他便来到这混乱领域，以孤星为名，以刀为伴，渡过了无知无觉的三年。　　孤星，是他的新名字，自从若曦离开他之后，他便认为自己是命犯天煞，终身孤独。　　楼梯声传来了沉重脚步声，打断了他的思绪，不用回头，他便已知道，在这个时刻，也只有岳阳楼的老板于跃才会上来。　　于跃右手提了一壶酒，走到孤星的旁边，拍了怕他的肩膀，坐下来，叹了一口气，说道：“三年了，自从你来到此地便是如此，如今，你还是没有改变。”　　孤星听罢，眼角嘴角低喃：“天涯海角有穷时，只是相思无尽处...无尽处，你知道酒的好处吗，最大的好处就是使人麻醉，忘记一切”　　旋即，转向于跃，说道：“此时此刻，你不想着逃亡，离开这混乱领域，哪来的闲心理我着悲情之人。”　　于跃环视四周，左手抚摸着酒坛，恋恋不舍的说道：“十年了，记得刚来此地时，最大的希望就是赚足了钱，回家过着安居乐业的日子，可是十年时间，我却在此成家立业，深深爱上了这里。如果不是天魔教打破了三分天下的微妙形势，又有谁舍得离开？”　　于跃站起身来，倒满一杯酒，一饮而尽，叹了一口气，再次说道：“不管你之前是什么人，经历什么事，我从不过问，我只知道，我们是朋友。此次，怕是我们最后一次相聚了。”　　听到于跃急促的下楼声，孤星站起身来，于跃的一声朋友，再次唤起了他的记忆，从窗户飞射而出，遥望北方，天魔教大军，即将到来。　　或许从来没人见过他的真面目，但是只要你是武林中人，就一定听过，武林中最年轻的高手，最飘逸的刀客——秦子渊，二十岁时，独闯林家堡，以一把飞雪刀，使整个林家堡覆灭。　　可惜，他因为一个女人，颓废不堪，失去踪影，隐居不出，葬送了大好的前程。　　当魔化元接到秦子渊的拜帖时，正在喝茶的他几乎跳了起来，无论是因为秦子渊的名望还是这混乱领域，他都要去迎接这一战，胜，则名利双收，败，则会再次保持三分天下，而天魔门也失去了现在的优势。　　三十年来，他从来没有如此激动和恐慌，任何一次的征战都会令他兴奋，这次，要改变了。　　孤星站在落雁岗上，望着清晨的第一丝阳光，回忆起和若曦第一次相见。 　“我叫若曦，曦的意思，就是清晨的太阳，所以，我就是像是这初升的太阳，温暖、可爱。”　　那是在岳州府时，他在岳阳河沉醉在周围的美景时，被一个清脆悦耳的声音打断，当他转眼望去，看到一个身穿翠绿连衣裙，手里拿着黄色的油纸伞，在向着船上的船夫介绍，而他们，也就是在哪里认识的。　　欢乐的时光总是短暂的，若曦为了他的安危，偷偷的跟他去林家堡，替他挡了林天的全力一击，身受重伤，不治而亡。　　“秦兄自三年前名声大噪后，便退隐江湖，魔某无缘一会，今日相见，喜不自禁。”一个洪厚的声音在身后响起，打断了孤星的思绪。　　“秦某已死，活着的只不过是一个孤独无依的人罢了，只是久居此地，不喜旁人破坏此地宁静，还望魔兄带领门众离开。”孤星头也不回，淡淡的说道。　　“孤星......”魔化元身后一人张大嘴巴说道，他无法想象，混乱领域的孤星，竟然是三年前被武林中人推崇为第一人的秦子渊。　　孤星这才回过头来，仔细打量几人，魔化元有着俊朗的面孔，看起来有三十余岁，可孤星知道，三十年前，他就已经开始为天魔门争霸天下，如此算来，至少也五十有余，只不过先天气功，能够克服衰老。　　魔化元身后的几人，其中有两个在混乱领域见到过，剩余四人，装饰如一，是魔化元手下大将。　　魔化元听到一人叫出孤星后，嘴角上扬，微微一笑，说道：“名震混乱领域的孤星竟然就是秦兄，实在让人无法想象，传闻孤星的般若掌法在混乱领域无人能敌，魔某想讨教一二。”　　魔化元此语很是高明，秦子渊的刀法在三年前都已经大成，因此被推崇为武林第一人，现在他避长就短，让秦子渊无法出刀，使用掌法迎敌，而他的胜算也就多了一些。　　秦子渊淡淡一笑，做出请的手势，不在言语。　　魔化元举起右掌，发出一道掌风，然后腾空而起，向着孤星掠去，双掌分上下连连发出掌风。　　秦子渊双腿微动，已经躲开魔化元的攻击，左掌向着魔化元的左肋击去，正是其必救之处。　　魔化元不愧是成名多年之人，经验丰厚，转身右闪，右手措刀，右上至下，向着秦子渊看去，左掌收回，放在胸前，右腿向着秦子渊踢去。　　谁知秦子渊根本不闪，左脚略微后退，左掌不变，已经诡异的穿过魔化元的防御，直击他的胸口。　　秦子渊的左掌击到胸口，魔化元顿时一阵胸闷，无法呼吸，魔化元急忙后退，惊骇的望着他。　　秦子渊淡淡一笑，没有追击，说道：“希望魔兄遵守诺言，离开混乱领域。”　　魔化元苦笑一下，说道：“恐怕非我能做主，需要请示门主定夺。”　　秦子渊微微皱眉，说道：“请魔兄回去告知天魔门主，如果他不肯退兵，那么秦某就会加入银龙门或剑影楼，望他三思。”　　秦子渊说完，施展轻功而去，剩下魔化元一干人。　　魔化元望着秦子渊离去，咬着牙说道：“没想到颓废三年，他的武功不但没有荒废，反而更加精进。”　　其中在混乱领域出现的一个人，望着秦子渊离开，低头沉思，不知在想些什么。　　“天魔门，退兵了？”听到这个消息，混乱领域的人仍有着不信。　　“是啊，真是奇怪，银龙门和剑影搂都没到，他们为什么退兵了呢？”　　“谁知道呢，不过我们已经不用搬家了。”一人接口道。　　秦子渊正坐在岳阳楼上，望着下方熙熙攘攘的人群，露出一丝笑意，三年来，这是他主动做的第一件事，其实他也很热爱这个地方，虽然混乱，但是人人没有伪装，小偷和强盗明目仗胆在大街上游动，如果东西被偷被抢，是在正常不过的事情，当然，如果你有实力，完全可以去抢回来，或者抢其他人的东西以作补偿。　　于跃走上岳阳楼，二层内也是非常热闹，人人在庆祝天魔门退兵，但是也有僻静之处，那就是秦子渊所在之处，依他的实力和孤僻，无人敢以靠近。　　于跃做到秦子渊旁边，眼睛里流出一丝热泪，嘴角微动，轻声说道：“谢谢，谢谢，恭喜。”　　秦子渊淡淡一笑，轻轻摇头说道：“我就知道你能猜到。”　　秦子渊当然明白于跃的意思，第一个谢谢，自然是谢谢他肯出手，挽救了真个混乱领域，第二个谢谢则是因为秦子渊为他的安居而出手，是把他当做朋友，恭喜，自然是恭喜他走出阴霾；虽然在混乱领域都不会过问别人的过去，但是他知道秦子渊一定有不平凡的过去，有着伤心事。　　于跃说道：“虽然我不知道你过去遇到了什么事，但是人生本就是充满欢乐和希望的。”　　秦子渊了拿起酒杯，陷入沉思，悠悠说道：“她当年对人生也是充满了希望，她是那么可爱，那么善良，她就像那清晨的阳光，温暖而不炙热、明亮而不耀眼、但又是那么短暂。”　　于跃接口说道：“生命中充满了意外，充满了欢乐，也充满一忧伤和无奈，没有人能左右事情的发展，但是却能去选择”　　“意外？”秦子渊轻哼一声说道：“意外让我遇到她，但是又意外的失去了她，不过如果再有一次机会，我是不会再失去她的。”　　秦子渊躺在自己的床上，手里拿着一幅图，上写：“天书无字，我命神机，有缘之人得我传承...破天地之机，得到成神...哈哈”　　就秦子渊知道而言，神机图分为三部分，每一部分有三十六张图，共一百零八章，而他只是修炼了第一部分，就达到了这种成就。　　神机图，修的是人之意念，和武学的功法，有着本质不同，更加的贴近天然。　　也正是昨夜，在思念若曦时，意境达到了一种玄妙的状态，完完全全参悟第一幅神机图，朦胧之中，有着让若曦复活的信息，才会再次“活”了过来，有着活下去的动力。"
  + "乌云飘过，遮盖了月亮的光芒，只能通过点点星光看到微弱的夜景，微风吹过，柳枝轻轻摇动，发出沙沙的响声。　　一道黑影腾空飞过，轻点柳枝，已然远去。　　混乱领域之外，一个人正在来回走动，看其面貌，正是白天和魔化元在一起的人，他面色焦急，遥望着南方，当他看到一个黑影来到时，急忙说道：“您终于来了，我知道了秦子渊的下落。”　　黑影落地无声，脸上蒙着的黑罩随着他的说话声微微而动：“他在哪里？”　　等待之人说道：“他就是混乱领域的孤星，当魔化元带领天魔门攻打混乱领域时，他向魔化元下了战帖，保住了混乱领域。”　　黑影眼中闪过凶芒，冷冷的说道：“哼，武林中的侠客，竟然会为这种地方出手，他倒是越活约回去了！对了，他现在功力如何？”　　那人接口说道：“他只出一招，魔化元已经败退，功力应该比之前更加精纯。”　　黑影之人略皱眉头，略微沉思，无法置信的问道：“颓废三年，武功竟然还有精进？真不可思议，无怪...”　　黑影顿时住口不言，看了看那人，再次说道：“我知道了，你回去领赏吧。”　　那人听了，露出贪婪的笑容，转身离去。　　待那人离去之后，黑影望向混乱领域的眼光里再次出现凶狠，发出一声冷哼，随即进入左后方的树林，拿出一块玉简，捏碎之后，盘膝坐下，闭目养神。　　微弱的灯光照亮着小屋，屋内设施简单而朴素，只有一张桌子，两把椅子，一个衣柜和一张床而已，秦子渊拿着第一幅神机图沉思，当他完全参悟第一部分神机图，就在冥冥之中有着感应，能够使云月儿复活，这也让他有着继续“活”下去的心态，但是具体如何做到，他现在无法知道。　　秦子渊突然感觉到一阵心悸，皱起眉头，眼里闪过一丝精光，自三年前刀法大成，武功和心境都渐入天道之感后，再也没有过这种感觉，如今再次出现，证明他会遇到生命危险。不过依他现在的修为，究竟是何人能够让他有这种感觉？　　秦子渊看了看床边的飞雪刀，虽然从不离身，三年来却从未出鞘，它静静的躺在那里，像是等待主人的下沉召唤。　　秦子渊把神机图放在床底，右手中指向着灯火一弹，闭上双眼，今夜，将会是他三年来最艰苦的一战。　　烛火应指而灭，屋内陷入沉寂，甚至失去了呼吸声，只能看到微不可查的月光。　　白、黑、红，成为鲜明的对比。　　他一身白衣，在这漆黑的夜里凌空而行，如若流星般一闪而逝。　　但是就这一瞬间，已经让人震撼于他的邪异，一张带着微笑的面孔，俊朗的近乎妖异，但是却带着血红的眼球，充满煞气，让人不寒而栗。　　白衣人停在混乱领域之外，轻轻落下，望向左边的树林。　　树林里走出一个黑衣之人，揭开脸色黑色的面罩，待面罩完全揭开，却能让武林中人震惊的无法言语，此人竟然就是林家堡的堡主——林天！　　林天向着白衣人拱手说道：“饮雪大人，我们已经发现秦子渊的踪迹，还请大人出手，以免他破坏我们的计划，不过不知为何，三年来，他的功力却是更加精进。”　　饮雪的眼睛闪出红光，微笑的说道：“此子武功心境因情而进入天道，是以无需苦加修炼，便会精进；啧啧，在凡间能有如此人物，还真是让人期待。”　　充满煞气的眼神，语气却是温柔婉转，强烈的反差，带来了极大的诱惑力。　　“可惜的是，他无法在饮雪大人手下逃生。”林天恨恨的说道。　　饮雪望了林天一眼，略带遗憾的说道：“如果不是为了那个东西，我还真不舍得杀掉这万年都难得一见的奇才。”　　“铛”的一声，飞雪刃从刀鞘弹出，秦子渊翻身而起，迅如闪电，抓去刀柄，脸上略带震骇，宝刀示警，自从以刀法大成，人刀合一之后，再也没有出现过之事。　　“秦兄果然是不世奇才，年仅二十余岁，刀法心境已经进入天道，而且这飞雪刀也是不凡之物，竟然会自动护主。”屋内出现一个白衣之人，淡淡的说道。　　秦子渊望着此人，心里充满惊骇，要知道，自他武功进入天道已来，没有人可以在他毫无所知的情况下，进入他十丈之内，可是眼前此人，出乎意料的出现在他的屋内，如果不是宝刃再次示警，他毫无所觉。　　“你究竟是谁？”秦子渊淡淡的问道。　　“我叫饮雪。”白衣之人说道：“不过我是谁不重要，重要的是，我今天的目的，就是取你性命。”　　“命”字刚刚落地，饮雪已经出掌击向秦子渊。　　秦子渊向后一步，施展那从神机图悟出的行云步，如若行云漂浮，随着饮雪的掌风晃动。　　“叮”的一声，漆黑的屋内出现晶亮的刀光，飞雪刀若天马行空，无迹可寻，若飞雪飘舞，借着饮雪来的掌风，倒卷向饮雪，带着凌冽的寒气。　　“竟然把借力使力融贯于刀法之声？”饮雪略带不屑又带有赞叹的声音轻吐。　　不过他仍然直击而出，握掌成拳，无视秦子渊的飞雪刀。　　拳头带着气流形成一股漩涡，穿过秦子渊的刀光，直接击到了秦子渊的胸膛。　　一股极大的力道侵入他的经脉，如冰一样的寒冷，却又如火一样灼热，两种不同的感觉在破坏他的经脉，让他无法忍受。　　秦子渊脑中顿时闪过神机图十八，倒退一步，左腿前踏，弯膝垂直，右腿向后，挺膝伸直，同时右手向前高举，左手后伸，延至右脚脚跟，形成一个圆。　　进入体内的力道顿时向着四肢百骸外散去，秦子渊运刀邪连劈饮雪，几道强大的劲风向着饮雪攻去。　　饮雪轻轻摇头，左拳再次向着秦子渊攻去。　　不料秦子渊接着饮雪的拳劲飞退，向着混乱领域的南面而去，快如疾风。　　饮雪脸上露出一丝轻蔑的笑容，右脚前踏，如若虚空消失一般，顿时出现在秦子渊的身后，一拳击去。　　飞雪刀刀影再次出现在秦子渊的身旁，如若漫天的飞雪卷风，形成一个漩涡，把他紧锁在漩涡之中。　　再次吐出一口鲜血，背后若冰似火的痛楚几乎让秦子渊像立即放弃。　　强提一口真气，秦子渊不理会背后的伤势，向前飞去。　　“咦”，饮雪轻轻的发出一声惊讶，一个凡人界的高手，竟然受他两拳不死。　　“再送你半拳。”饮雪笑着说道，不再追击，左拳向着秦子渊一晃，强大的气流疾飞而去。　　秦子渊发出痛苦的叫声，强大的拳劲把他强凝的真气击散，昏迷过去，被强大的气流带着他向前飞去。"; //本章的所有内容
  List<String> texts = [];
  int nowIndex = 0;

  double textSize = 18.0; //文字大小
  double lineSpring = 1.5; //行距

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          value = animation.value;
          startCancelAnimate();
          if (animation.value == 1.0) {
            setState(() {
              if (nextBook) {
                nowIndex++;
                if (nowIndex == texts.length) {
                  nowIndex = 0;
                }
              }
              a = null;
              style = null;
            });
          }
        });
      });
    initText();
  }

  void initText() {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: textSize,
      height: lineSpring,
    );
    int lastIndex = 0;
    double maxHeight = Util.getMaxHeight("测", textStyle);
    int maxLine = (size.height - 30) ~/ maxHeight;
    print("maxLine:$maxLine");
    while(lastIndex < text.length) {
      lastIndex = getLastIndex(textStyle, lastIndex, text, maxLine);
    }
  }

  int getLastIndex(TextStyle textStyle, int startIndex, String text, int maxLine) {
    double maxWidth = size.width - 37.0;
    double nowWidth = 0.0;
    int nowLine = 1;
    for (int i = startIndex; i < text.length; i++) {
      double width = Util.findAllWidth(text.substring(i, i+1), textStyle);
      if (nowWidth + width > maxWidth) {
        nowLine++;
        nowWidth = width;
      } else {
        nowWidth += width;
      }
      if (nowLine > maxLine) {
        print("字符:${text.substring(startIndex, (startIndex+i)~/2)}");
        print("字符:${text.substring((startIndex+i)~/2, i)}");
        texts.add(text.substring(startIndex, i));
        print("-------一节结束了-------");
        return i;
      }
    }

    print("字符:${text.substring(startIndex, text.length)}");
    print("-------一节结束了-------");
    texts.add(text.substring(startIndex,text.length));
    return text.length;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e){
        if (!controller.isCompleted) {
          controller.stop();
        }
        nextBook = true;
//        print("onTapDown e：${e.localPosition.toString()}");
        if (e.localPosition.dx > DataConfig.appSize.width / 3 * 2) {
          if (e.localPosition.dy < DataConfig.appSize.height / 3) {
            style = BookPageViewPainter.STYLE_TOP_RIGHT;
          } else if (e.localPosition.dy < DataConfig.appSize.height / 3 * 2) {
            style = BookPageViewPainter.STYLE_CENTER_RIGHT;
          } else {
            style = BookPageViewPainter.STYLE_BOTTOM_RIGHT;
          }
        } else if (e.localPosition.dx < DataConfig.appSize.width / 3) {
          style = BookPageViewPainter.STYLE_LEFT;
          nowIndex--;
          if (nowIndex < 0) {
            nowIndex = texts.length - 1;
          }
          nextBook = false;
        }
        nextOffset = e.localPosition;
      },
      onPointerMove: (e){
        setState(() {
          if (style == BookPageViewPainter.STYLE_CENTER_RIGHT || style == BookPageViewPainter.STYLE_LEFT) {
            a = Offset(e.localPosition.dx, size.height - 1);
            initPoint(size);
          } else {
            a = e.localPosition;
            initPoint(size);
            if (calcPointCX(e.localPosition, f) < 0) {
              calcPointAByTouchPoint();
              initPoint(size);
            }
          }
          if ((e.localPosition.dx - nextOffset.dx).abs() > 10.0 || (e.localPosition.dy - nextOffset.dy).abs() > 10.0) {
            if (e.localPosition.dx <= nextOffset.dx) {
              nextBook = true;
            } else {
              nextBook = false;
            }
            nextOffset = e.localPosition;
          }

        });
      },
      onPointerUp: (e){
        temp = a;
        controller.forward(from: 0.0);
      },
      child: CustomPaint(
        size: size,
        painter: BookPageViewPainter(a, f, g, e, h, c, j, b, k, d, i, style, texts[nowIndex], texts[nowIndex + 1 == texts.length ? 0 : nowIndex + 1], textSize, lineSpring),
      ),
    );
  }

  void startCancelAnimate() {
    if (value != 1.0 && temp != null) {
      if (nextBook) {
        if (style == BookPageViewPainter.STYLE_TOP_RIGHT) {
          a = Offset(temp.dx - size.width * value, temp.dy * (1 - value) - 1);
        } else {
          a = Offset(temp.dx - size.width * value, temp.dy + value * (size.height - temp.dy) - 1);
        }
      } else {
        if (style == BookPageViewPainter.STYLE_TOP_RIGHT) {
          a = Offset(temp.dx + (size.width - temp.dx) * value - 1, temp.dy * (1 - value) - 1);
        } else {
          a = Offset(temp.dx + (size.width - temp.dx) * value - 1, temp.dy + value * (size.height - temp.dy) - 1);
        }
      }
      initPoint(size);
    }
  }

  /*
   * 计算C点的X值
   * @param a
   * @param f
   * @return
   */
  double calcPointCX(Offset a, Offset f){
    if (a == null || f == null) {
      return 0;
    }
    Offset g,e;
    g = new Offset((a.dx + f.dx) / 2, (a.dy + f.dy) / 2);
    e = new Offset(g.dx - (f.dy - g.dy) * (f.dy - g.dy) / (f.dx - g.dx), f.dy);
    return e.dx - (f.dx - e.dx) / 2;
  }

  /*
   * 如果c点x坐标小于0,根据触摸点重新测量a点坐标
   */
  void calcPointAByTouchPoint(){
    double w0 = DataConfig.appSize.width - c.dx;

    double w1 = (f.dx - a.dx).abs();
    double w2 = DataConfig.appSize.width * w1 / w0;
    double dx = (f.dx - w2).abs();

    double h1 = (f.dy - a.dy).abs();
    double h2 = w2 * h1 / w1;
    double dy = (f.dy - h2).abs();
    a = Offset(dx, dy);
  }

  //初始化点
  void initPoint(Size size) {
    if (style == BookPageViewPainter.STYLE_TOP_RIGHT) {
      f = Offset(size.width, 0);
    } else if(style == BookPageViewPainter.STYLE_BOTTOM_RIGHT) {
      f = Offset(size.width, size.height);
    } else if(style == BookPageViewPainter.STYLE_CENTER_RIGHT) {
      f = Offset(size.width, size.height);
    } else if (style == BookPageViewPainter.STYLE_LEFT) {
      f = Offset(size.width, size.height);
    }
    g = Offset((a.dx + f.dx) / 2, (a.dy + f.dy) / 2);
    e = Offset(g.dx - (f.dy - g.dy) * (f.dy - g.dy) / (f.dx - g.dx), f.dy);
    h = Offset(f.dx, g.dy - (f.dx - g.dx) * (f.dx - g.dx) / (f.dy - g.dy));
    c = Offset(e.dx - (f.dx - e.dx) / 2, f.dy);
    j = Offset(f.dx, h.dy - (f.dy - h.dy) / 2);
    b = getIntersectionPoint(a,e,c,j);
    k = getIntersectionPoint(a,h,c,j);
    d = Offset((c.dx + e.dx * 2 + b.dx) / 4, (2 * e.dy + c.dy + b.dy) / 4);
    i = Offset((j.dx + 2 * h.dx + k.dx) / 4, (2 * h.dy + j.dy + k.dy) / 4);
  }

  /*
   * 获得交叉点的坐标
   */
  Offset getIntersectionPoint(Offset lineOnePointOne, Offset lineOnePointTwo, Offset lineTwoPointOne, Offset lineTwoPointTwo) {
    double x1,y1,x2,y2,x3,y3,x4,y4;
    x1 = lineOnePointOne.dx;
    y1 = lineOnePointOne.dy;
    x2 = lineOnePointTwo.dx;
    y2 = lineOnePointTwo.dy;
    x3 = lineTwoPointOne.dx;
    y3 = lineTwoPointOne.dy;
    x4 = lineTwoPointTwo.dx;
    y4 = lineTwoPointTwo.dy;
    double pointX =((x1 - x2) * (x3 * y4 - x4 * y3) - (x3 - x4) * (x1 * y2 - x2 * y1))
        / ((x3 - x4) * (y1 - y2) - (x1 - x2) * (y3 - y4));
    double pointY =((y1 - y2) * (x3 * y4 - x4 * y3) - (x1 * y2 - x2 * y1) * (y3 - y4))
        / ((y1 - y2) * (x3 - x4) - (x1 - x2) * (y3 - y4));

    return  new Offset(pointX,pointY);
  }
}

//绘制
class BookPageViewPainter extends CustomPainter {
  static const String STYLE_LEFT = "STYLE_LEFT"; //点击左边区域
  static const String STYLE_CENTER = "STYLE_CENTER"; //点击中间区域
  static const String STYLE_TOP_RIGHT = "STYLE_TOP_RIGHT"; //右上角开始翻书
  static const String STYLE_CENTER_RIGHT = "STYLE_CENTER_RIGHT"; //中间开始翻书
  static const String STYLE_BOTTOM_RIGHT = "STYLE_BOTTOM_RIGHT"; //右下角开始翻书

  Offset a,f,g,e,h,c,j,b,k,d,i;
  final String style;
  double textSize; //文字大小
  double lineSpring; //行距

  String nowText;
  String nextText;

  BookPageViewPainter(this.a, this.f, this.g, this.e, this.h, this.c, this.j, this.b, this.k, this.d, this.i, this.style, this.nowText, this.nextText, this.textSize, this.lineSpring);

  var paints = Paint()
//    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.transparent;

  var paintA = Paint()
//    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Color(0xFFC2B28F); //0xFFD9B98F

  var paintC = Paint()
//    ..style = PaintingStyle.fill
//    ..blendMode = BlendMode.dstOver //折叠部分处理
    ..isAntiAlias = true
    ..color = Color(0xFFD7C7A9);

  var paintB = Paint()
//    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOver //折叠部分处理
    ..isAntiAlias = true
    ..color = Color(0xFFC2B28F);

  @override
  void paint(Canvas canvas, Size size) {
    if (a == null || style == null || f == null || g == null || e == null || h == null) {
      canvas.drawPath(getPathDefault(size), paintA);
      drawText(canvas, nowText, Offset(15.0, 30.0));
      return;
    }
    drawText(canvas, nextText, Offset(15.0, 30.0));
    canvas.drawPath(getPathDefault(size), paints);

    //绘制A区域
    canvas.drawPath(pathA(size), paintA);

    var combinec = Path.combine(PathOperation.intersect, pathC(size), pathA(size));
    var combineC = Path.combine(PathOperation.difference, pathC(size), combinec);
    var pathc;
    if (style == STYLE_CENTER_RIGHT || style == STYLE_LEFT) {
      paintC.blendMode = BlendMode.srcOver;
      pathc = pathC(size);
    } else {
      paintC = Paint()
        ..isAntiAlias = true
        ..color = Color(0xFFD7C7A9);
      pathc = combineC;
    }

    //绘制C区域
    canvas.drawPath(pathc, paintC);

    //绘制B区域
    canvas.drawPath(pathB(size), paintB);



    var combine = Path.combine(PathOperation.intersect, getPathDefault(size), pathA(size));
    canvas.clipPath(combine);
    drawText(canvas, nowText, Offset(15.0, 30.0));


  }

  //默认的path
  Path getPathDefault(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  Path pathA(Size size) {
    Path pathA;
    if (style == STYLE_TOP_RIGHT) {
      pathA = pathAFromRightTop(size);
    } else if (style == STYLE_BOTTOM_RIGHT) {
      pathA = pathAFromRightBottom(size);
    } else if (style == STYLE_CENTER_RIGHT || style == STYLE_LEFT) {
      pathA = pathAFromRightBottom(size);
    }
    return pathA;
  }

  //区域A的路径
  Path pathAFromRightBottom(Size size) {
    Path pathA = new Path();
    pathA.lineTo(0, size.height);
    pathA.lineTo(c.dx, c.dy); //移动到c点
    pathA.quadraticBezierTo(e.dx, e.dy, b.dx, b.dy); //c - b的贝塞尔曲线
    pathA.lineTo(a.dx, a.dy); //移动到a点
    pathA.lineTo(k.dx, k.dy); //移动到k点
    pathA.quadraticBezierTo(h.dx, h.dy, j.dx, j.dy); //画k-j的贝塞尔曲线
    pathA.lineTo(size.width, 0); //移动到右上角
    pathA.close(); //闭合区域
    return pathA;
  }

  //区域A的路径
  Path pathAFromRightTop(Size size) {
    Path pathA = new Path();
    pathA.lineTo(c.dx, c.dy); //移动到c点
    pathA.quadraticBezierTo(e.dx, e.dy, b.dx, b.dy); //c - b的贝塞尔曲线
    pathA.lineTo(a.dx, a.dy); //移动到a点
    pathA.lineTo(k.dx, k.dy); //移动到k点
    pathA.quadraticBezierTo(h.dx, h.dy, j.dx, j.dy); //画k-j的贝塞尔曲线
    pathA.lineTo(size.width, size.height); //移动到右下角
    pathA.lineTo(0, size.height);

    pathA.close(); //闭合区域
    return pathA;
  }

  //区域C的路径
  Path pathC(Size size) {
    Path pathC = new Path();
    pathC.moveTo(i.dx, i.dy);
    pathC.lineTo(d.dx, d.dy);
    pathC.lineTo(b.dx, b.dy);
    pathC.lineTo(a.dx, a.dy);
    pathC.lineTo(k.dx, k.dy);
    pathC.close();
    return pathC;
  }

  //区域B的路径
  Path pathB(Size size) {
    Path pathB = new Path();
    pathB.lineTo(0, size.height);
    pathB.lineTo(size.width, size.height);
    pathB.lineTo(size.width, 0);
    pathB.close();
    return pathB;
  }


  //绘制横坐标的底部文字
  void drawText(Canvas canvas, String text, Offset offset){
    TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize,
          height: lineSpring,
        ),
      ),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0.0, maxWidth: DataConfig.appSize.width - 30)
      ..paint(canvas, offset);
  }

  @override
  bool shouldRepaint(BookPageViewPainter oldDelegate) {
    return a != oldDelegate.a;
  }

}