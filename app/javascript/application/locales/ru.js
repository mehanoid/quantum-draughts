export default {
  copyright: 'Олег Григорьев',
  commons: {
    white: 'Белые',
    black: 'Чёрные',
  },
  enums: {
    match: {
      statuses: {
        new_match: 'Новая',
        started: 'Начата',
      },
    },
  },
  models: {
    attributes: {
      match: {
        startedAt: 'Время начала',
        ruleset: 'Правила',
      },
    },
  },
  rulesets: {
    english: 'Английские',
    russian: 'Русские',
  },
  matchesIndex: {
    startGame: 'Новая игра',
    currentMatches: 'Текущие партии',
  },
  matchesList: {
    players: 'Участники',
    state: 'Статус',
    backToGame: 'Вернуться к игре',
    join: 'Присоединиться',
    watch: 'Наблюдать',
  },
  matchesShow: {
    matchInfo: 'О партии',
    matchHistory: 'История ходов',
    beatenDraughts: 'Битые шашки',
    join: 'Присоединиться',
    waitingForPlayers: 'Ожидание других игроков',
    yourTurn: 'Ваш ход',
    opponentTurn: 'Ход противника',
    whiteTurn: 'Ход белых',
    blackTurn: 'Ход чёрных',
    anonymousPlayerName: 'Игрок %{id}',
    noPlayer: 'Не назначен',
  },
  matchHistory: {
    currentTurn: 'Текущий ход',
  },
  matchForm: {
    newMatch: 'Новая игра',
    start: 'Начать',
  },
  buttons: {
    cancel: 'Отмена',
    close: 'Закрыть',
  },
  errors: {
    connectionError: 'Не удаётся подключиться к серверу',
  },
}
