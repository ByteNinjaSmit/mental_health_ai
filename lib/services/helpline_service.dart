import '../models/helpline_model.dart';

class HelplineService {
  static List<HelplineModel> helplines = [
    HelplineModel(
      name: "Kiran Mental Health Helpline",
      phone: "1800-599-0019",
      website: "https://kiranhelpline.in",
      description: "24/7 helpline for mental health support in India.",
    ),
    HelplineModel(
      name: "Vandrevala Foundation",
      phone: "1860-266-2345",
      website: "https://vandrevalafoundation.com",
      description: "Free mental health support and counseling.",
    ),
    HelplineModel(
      name: "Snehi",
      phone: "91-11-24520542",
      website: "http://www.snehi.org",
      description: "Helpline for emotional support and mental health.",
    ),
    HelplineModel(
      name: "AASRA",
      phone: "91-9820466726",
      website: "http://www.aasra.info/",
      description: "24/7 Helpline for emotional support.",
    ),
  ];
}