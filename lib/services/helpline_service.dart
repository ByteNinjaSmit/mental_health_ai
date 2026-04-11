import '../models/helpline_model.dart';

class HelplineService {
  static List<HelplineModel> helplines = [
    HelplineModel(
      name: "AASRA",
      phone: "91-9820466726",
      website: "http://www.aasra.info/",
      description: "24/7 Helpline for emotional support",
    ),
    HelplineModel(
      name: "iCALL",
      phone: "9152987821",
      website: "http://icallhelpline.org/",
      description: "TISS Mental Health Helpline",
    ),
    HelplineModel(
      name: "Kiran Helpline",
      phone: "1800-599-0019",
      website: "https://www.mohfw.gov.in/",
      description: "Government mental health helpline",
    ),
  ];
}