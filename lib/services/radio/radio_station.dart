class RadioStation {
  String name;
  String tags;
  String iconUrl;
  String streamUrl;

  RadioStation(
    {
    required this.name, 
    required this.tags,
    required this.iconUrl, 
    required this.streamUrl,
    }
  );

  @override
  String toString(){
    return 'Radio Station $name ($tags) with icon $iconUrl and stream $streamUrl';
  }
}