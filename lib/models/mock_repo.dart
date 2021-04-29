import 'msg.dart';
import 'person.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

final mockNewMessages = [
  Message(
    uuid: uuid.v4(),
    body: "hey, naber ortaağaaam??!",
    saved: false,
    from: Person(
      name: "Yarmagül",
      username: "yarma",
      photoURL: "",
    ),
  ),
  Message(
    uuid: uuid.v4(),
    body: "let's destroy the poor people, huhhuhaha!",
    saved: false,
    from: Person(
      name: "Bill Gates",
      username: "bill",
      photoURL: "",
    ),
  ),
  Message(
    uuid: uuid.v4(),
    body: "I'll call you later, sir!",
    saved: false,
    from: Person(
      name: "Obama",
      username: "obama",
      photoURL: "",
    ),
  ),
];

final mockSavedMessages = [
  Message(
    uuid: uuid.v4(),
    body: "Ula oglum nerelerdesin sen??? açsena la şu teli...",
    saved: true,
    from: Person(
      name: "Cemalettin",
      username: "cemo",
      photoURL: "",
    ),
  ),
  Message(
    uuid: uuid.v4(),
    body: "let's do diz thug style, maan. i am down wit ya til' da very end!",
    saved: true,
    from: mocklocalUsers[0],
  ),
];

final mocklocalUsers = [
  Person(
    name: "Tupac",
    username: "2pac",
    photoURL: "",
  ),
  Person(
    name: "Muzaffer",
    username: "muzo",
    photoURL: "",
  ),
  Person(
    name: "Güllü",
    username: "gulo",
    photoURL: "",
  ),
];
