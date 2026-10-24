class AtmStatusModel {
  final bool emServico;
  final bool temDinheiro;
  final bool temPapel;

  const AtmStatusModel({
    required this.emServico,
    required this.temDinheiro,
    required this.temPapel,
  });

  bool get ativoComDinheiroEPapel =>
      emServico && temDinheiro && temPapel;

  bool get apenasDinheiro =>
      emServico && temDinheiro && !temPapel;

  bool get apenasPapel =>
      emServico && !temDinheiro && temPapel;

  bool get foraDeSistema => !emServico;
}