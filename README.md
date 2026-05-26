# Pulse Replay Analytics

Dashboard Flutter Web para analisar o historico exportado pelo Google Takeout do YouTube e YouTube Music.

O projeto foi pensado como um SaaS moderno de analytics de consumo musical e midia: visual dark premium, navegacao fluida, filtros avancados, rankings, graficos interativos e insights automaticos a partir do historico importado.

## O Que Ele Faz

- Importa JSON do Google Takeout com historico do YouTube e YouTube Music.
- Analisa videos assistidos, musicas ouvidas, artistas, canais, generos e periodos.
- Exibe metricas gerais como total assistido, tempo estimado, media diaria, streak e plataforma mais usada.
- Conta musicas diferentes ouvidas no periodo selecionado.
- Mostra Top Artists e Top Videos com plays agregados.
- Permite explorar o historico completo em uma interface otimizada.
- Aplica filtros por data, busca, genero e plataforma.
- Gera insights automaticos sobre habitos de consumo.
- Usa graficos responsivos para tendencias, distribuicao por plataforma, generos e horarios mais ativos.

## Stack

- Flutter 3+
- Material 3
- Riverpod
- go_router
- flutter_animate
- fl_chart
- google_fonts
- responsive_framework
- shimmer
- glassmorphism
- freezed / json_serializable
- file_picker

## Estrutura

```txt
lib/
 |-- core/
 |-- features/
 |   |-- analytics/
 |   |-- artists/
 |   |-- dashboard/
 |   |-- history/
 |   |-- insights/
 |   |-- settings/
 |   `-- videos/
 |-- models/
 |-- routes/
 |-- services/
 |-- shared/
 |-- theme/
 `-- widgets/
```

## Formato Do JSON

O app espera um arquivo JSON exportado pelo Google Takeout contendo uma lista de itens de historico. Exemplo:

```json
{
  "header": "YouTube Music",
  "title": "Watched Negro Drama",
  "titleUrl": "https://music.youtube.com/watch?v=o50J2xg8-sU",
  "subtitles": [
    {
      "name": "Racionais MC's - Topic",
      "url": "https://www.youtube.com/channel/UC0-clSqGiArqh1CaskKiu3g"
    }
  ],
  "time": "2026-05-25T21:39:03.971Z",
  "products": ["YouTube"],
  "activityControls": ["YouTube watch history"]
}
```

Tambem sao aceitos arquivos onde a lista venha diretamente na raiz, ou dentro de chaves como `items` ou `history`.

## Como Rodar

Pre-requisitos:

- Flutter instalado e configurado.
- Suporte a Web habilitado no Flutter.

Confira a instalacao:

```bash
flutter doctor
```

Instale as dependencias:

```bash
flutter pub get
```

Rode no navegador:

```bash
flutter run -d chrome
```

Ou rode como servidor web local:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

Depois acesse:

```txt
http://127.0.0.1:8080
```

## Build Web

Para gerar o build de producao:

```bash
flutter build web
```

Os arquivos finais ficam em:

```txt
build/web
```

## Como Usar

1. Exporte seu historico pelo Google Takeout.
2. Selecione os dados de YouTube e YouTube Music.
3. Baixe o arquivo exportado e localize o JSON de historico.
4. Abra o Pulse Replay Analytics.
5. Clique em `Importar JSON` ou na area de upload.
6. Use os filtros para analisar periodos, generos, plataformas, artistas e canais.

## Metricas Principais

- Total assistido.
- Total de musicas.
- Musicas diferentes no periodo.
- Tempo estimado consumido.
- Media diaria.
- Streak de consumo.
- Top artista.
- Top canal.
- Top genero.
- Plataforma mais usada.

## Privacidade

O processamento acontece localmente no navegador. O JSON importado nao e enviado para nenhum backend por este projeto.

Ainda assim, arquivos reais do Google Takeout podem conter dados pessoais, historico de consumo e timestamps. Nao commite nem publique arquivos reais de Takeout no repositorio.

## Status

Projeto em desenvolvimento ativo. A base atual ja compila para Flutter Web e inclui dashboard, filtros, parser, rankings, graficos e paginas principais.
