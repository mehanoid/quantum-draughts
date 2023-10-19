# Quantuum Draughts

**Quantuum Draughts** (квантовые шашки) - вариация шашек с элементами квантовой механики, вдохновлённая игрой [квантовые шахматы](https://ru.wikipedia.org/wiki/%D0%9A%D0%B2%D0%B0%D0%BD%D1%82%D0%BE%D0%B2%D1%8B%D0%B5_%D1%88%D0%B0%D1%85%D0%BC%D0%B0%D1%82%D1%8B).
В отличие от традиционных шашек, в этой игре фигуры не имеют определенной позиции на доске, а находятся в состоянии вероятности нахождения в разных клетках.

Каждый ход перемещает выбранную шашку не на одну клетку, а сразу на несколько, что приводит к её переходу в состояние [суперпозиции](https://ru.wikipedia.org/wiki/%D0%9A%D0%B2%D0%B0%D0%BD%D1%82%D0%BE%D0%B2%D0%B0%D1%8F_%D1%81%D1%83%D0%BF%D0%B5%D1%80%D0%BF%D0%BE%D0%B7%D0%B8%D1%86%D0%B8%D1%8F). То есть, шашка одновременно находится в нескольких возможных позициях, пока не произойдет
[наблюдение](https://ru.wikipedia.org/wiki/%D0%98%D0%B7%D0%BC%D0%B5%D1%80%D0%B5%D0%BD%D0%B8%D0%B5_(%D0%BA%D0%B2%D0%B0%D0%BD%D1%82%D0%BE%D0%B2%D0%B0%D1%8F_%D0%BC%D0%B5%D1%85%D0%B0%D0%BD%D0%B8%D0%BA%D0%B0)).
Как известно из квантовой механики, наблюдение невозможно без взаимодействия с объектом, таким образом наблюдение за шашкой происходит при попытке хода, что приводит к
[коллапсу суперпозиции](https://ru.wikipedia.org/wiki/%D0%A0%D0%B5%D0%B4%D1%83%D0%BA%D1%86%D0%B8%D1%8F_%D1%84%D0%BE%D0%BD_%D0%9D%D0%B5%D0%B9%D0%BC%D0%B0%D0%BD%D0%B0). Тогда шашка окончательно выбирает свою позицию. При этом может оказаться, что клетка, с которой вы пытались сделать ход, пуста, и ход не удастся.

Также возможна ситуация, когда шашка бьёт другую шашку с определенной вероятностью. В этом случае побитая шашка находится в состоянии "жива и мертва одновременно", аналогично известному мысленному эксперименту с [котом Шрёдингера](https://ru.wikipedia.org/wiki/%D0%9A%D0%BE%D1%82_%D0%A8%D1%80%D1%91%D0%B4%D0%B8%D0%BD%D0%B3%D0%B5%D1%80%D0%B0).
Она также вступает в [квантовую запутанность](https://ru.wikipedia.org/wiki/%D0%9A%D0%B2%D0%B0%D0%BD%D1%82%D0%BE%D0%B2%D0%B0%D1%8F_%D0%B7%D0%B0%D0%BF%D1%83%D1%82%D0%B0%D0%BD%D0%BD%D0%BE%D1%81%D1%82%D1%8C) с шашкой, побившей её. Это означает, что состояние побитой шашки связано с состоянием шашки, которая ее побила, и изменение состояния одной шашки *мгновенно* влияет на другую (происходит "кошмарное дальнодействие", как выразился Альберт Эйнштейн). Теперь эти две шашки не могут рассматриваться по отдельности, они образуют единую систему, описываемую общей [волновой функцией](https://ru.wikipedia.org/wiki/%D0%92%D0%BE%D0%BB%D0%BD%D0%BE%D0%B2%D0%B0%D1%8F_%D1%84%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D1%8F). В интерфейсе игры состояние запутанных шашек показывается полоской по краю шашки, когда пользователь выбрал одну из остальных шашек. Если полоска отсутствует, это означает, что состояния шашек не связаны. Если полоска полностью заполнена (светлая) - это значит, что обнаружить на этом месте шашку можно тогда и только тогда, когда выбранная шашка находится на указанной пользователем клетке. Если полоска не заполнена (тёмная), это значит, что невозможно обнаружить обе эти шашки стоящими на указанных местах одновременно (либо одна, либо другая).

На данный момент игра еще не полностью завершена. Возможно, когда-нибудь я её доделаю =)

В рамках проекта была предпринята попытка реализовать два набора правил - английских и русских шашек. Однако в ходе разработки стало понятно, что поведение квантовой дамки в русских шашках слишком непредсказуемо и нарушает ход игры. В связи с этим возник выбор: либо придумать и внести дополнительные коррекции в правила квантовых ходов для русских шашек, либо отказаться от русских шашек и оставить только английские - вариант, который, скорее всего, будет выбран.
