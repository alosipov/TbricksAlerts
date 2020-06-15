# TbricksAlerts
GUI automation task

Мое решение автоматизации какой-либо задачи 
и оно наглядно отображает понимание того,
как устроены графические приложения, как можно получить доступ
к тем или иным элементам GUI, обработать информацию и что-то с
этим сделать. Что очень важно и полезно знать при тестировании
графических интерфейсов, тем более, что для меня красивые улыбки
людей важнее финансовых активов и котировок на бирже =) 

Проблематика:
Ошибки, возникающие в процессе работы любой торговой стратегии,
могут нанести критический урон бизнесу за очень короткий период. Поэтому их необходимо
очень быстро = моментально отлавливать и отслеживать. 

Парсинг лога на стороне бекэнда и отправка сообщения в системы мониторинга
может оказать пагубное влияние на латенси в обработке того или иного события.

Во фронте можно настроить раскладку со всеми необходимыми окнами
для мониторинга работы стратегий и сервисов (ошибки, реджекты, загрузка пямяти конкретным сервисом и тд)

Одна из задач инженера сопровождения своевременно уведомить трейдера о проблеме в той или иной стратегии.

Я разработал скрипт аля бот – это мой некий MVP, который в определенный интервал проверяет
во фронтэнде необходимые окна на наличие тех или иных сообщений и согласно, заложенной мною логике,
отправляет эту информацию в чат Microsoft Teams команды.

Те данное решение минимализирует время обнаружения ошибки и позволяет оценить ее критичность всей команде сразу. И, естесственно, позволяет инженеру высвободить немного рабочего времени для изучения подобных штук и новых инструментов автоматизации =) 

Покажу, как работает, на примере окна с Active Alerts
