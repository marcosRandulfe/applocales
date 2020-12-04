
class Local{
  final String name;
  final String address;
  final String opening_hours;
  final int take_away;
  final int deliverys;
  final String restaurant_menu;
  final String whatsapp;
  final String web;
  final String email;
  final String url_foto;
  final List phones;
  final String category;
  
  Local({this.name, this.address,this.opening_hours,
          this.take_away,this.deliverys,this.restaurant_menu,
          this.whatsapp,this.web,this.email,this.url_foto,this.phones,this.category});
  
  factory Local.fromJson(Map<String, dynamic> json){
    return Local(
      name: json['name'],
      address: json['address'],
      opening_hours: json['opening_hours'],
      take_away: json['take_away'],
      deliverys: json['deliverys'],
      restaurant_menu: json['restaurant_menu'],
      whatsapp: json['whatsapp'],
      web: json['web'],
      email: json['email'],
      url_foto: json['url_foto'],
      phones: json['phones'],
      category: json['category'],
    );
  }

  bool contains(String string){
    if(this.name.toLowerCase().contains(string.toLowerCase()) 
        || this.address.toLowerCase().contains(string.toLowerCase())){
      return true;
    }
    return false;
  }
}