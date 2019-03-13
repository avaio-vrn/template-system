Флешесы
```
'flash--apply'                    - галка на зеленом
'flash--alert', 'flash--error'    - крест на красном
'flash--info'                     - восклицательный знак на желтом
```

При появлении конфирма к body присвоить класс flashabove


Всплывающее окно
```
<div class='flash'>
	<span class='flash-icon flash--apply'></span>
  <div class='notice'>
    Какой-либо текст (сколько угодно)
  </div>
	<span class='close-flash'></span>
</div>
```

Диалог
```
<div class='flash'>
	<span class='flash-icon flash--apply'></span>
  <div class='notice'>
    Вы согласны с нашем осознанием духовных ценностей и интерпретации понимания окружающей среды?
  </div>
  <span class='flash-button'>Да</span>
  <span class='flash-button'>Нет</span>
	<span class='close-flash'></span>
</div>
```
