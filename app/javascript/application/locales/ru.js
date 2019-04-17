export default {
  copyright: 'Олег Григорьев',
  commons: {
    white: 'Белые',
    black: 'Чёрные',
    anonymousPlayerName: 'Игрок %{id}',
  },
  enums: {
    match: {
      statuses: {
        new_match: 'Новая',
        started: 'Начата',
      },
    },
  },
  guestWelcomeForm: {
    title: 'Представьтесь, пожалуйста',
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
  rulesetsFull: {
    english: 'Английские шашки',
    russian: 'Русские шашки',
  },
  matchesIndex: {
    startGame: 'Новая игра',
    tabs: {
      allMatches: 'Текущие партии',
      myMatches: 'Мои партии',
    },
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
    next: 'Далее',
  },
  errors: {
    connectionError: 'Не удаётся подключиться к серверу',
    requestError: 'Ошибка выполнения запроса',
    internalServerError: 'Внутренняя ошибка сервера',
  },
  validation: {
    errors: {
      required: 'Заполните поле',
      maxLength: 'Максимум %{count} символов',
    },
  },
}
