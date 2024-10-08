export default {
  copyright: 'Олег Григорьев',
  commons: {
    white: 'Белые',
    black: 'Чёрные',
    anonymousPlayerName: 'Игрок %{id}',
    noData: 'Нет данных',
  },
  enums: {
    match: {
      statuses: {
        new_match: 'Новая',
        started: 'Начата',
        finished: 'Завершена',
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
        finishedAt: 'Время завершения',
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
      currentMatches: 'Текущие партии',
      myMatches: 'Мои партии',
    },
  },
  matchesList: {
    players: 'Участники',
    state: 'Статус',
    backToGame: 'Вернуться к игре',
    showDetails: 'Подробнее',
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
    youWon: 'Вы победили',
    youLose: 'Вы проиграли',
    whiteWon: 'Победа белых',
    blackWon: 'Победа чёрных',
  },
  matchHistory: {
    currentTurn: 'Текущий ход',
  },
  matchForm: {
    newMatch: 'Новая игра',
    start: 'Начать',
    rulesets: {
      english: 'Английские (рекомендуется)',
      russian: 'Русские',
    },
  },
  buttons: {
    cancel: 'Отмена',
    close: 'Закрыть',
    next: 'Далее',
  },
  errors: {
    disconnected: 'Соединение разорвано',
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
  aboutGame: {
    title: 'Об игре'
  },
  menu: {
    matches: 'Партии'
  }
}
