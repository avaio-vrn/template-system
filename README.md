# TemplateSystem

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'template_system'
```

And then execute:

$ bundle

Or install it yourself as:

$ gem install template_system

## Usage
***
## Заголовок второго порядка
```html
<div class="template">
<h2 class="path-0">Заголовок второго порядка</h2>
</div>
```
## Заголовок третьего порядка
```html
<div class="template">
<h3 class="path-0">Заголовок третьего порядка</h3>
</div>
```
<p>Крупный текст</p>
```html
<div class="template">
<p class="big-txt path-0">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>
```
<p>Текст</p>
```html
<div class="template">
<p class="normal-txt path-0">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>
```
<p>Мелкий текст</p>
```html
<div class="template">
<p class="small-txt path-0">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
</div>
```
<p>Цитата(текст и ссылка)</p>
```html
<div class="template">
<div class="quote">
<span class="quote-span">Папа Карло застукал Буратино ночью под одеялом с каталогом IKEA... И понеслось! Но не тут-то было!</span>
<a class="quote-link" href="">Узнать больше</a>
</div>
</div>
```
<p>Список с квадратами</p>
```html
<div class="template">
<ul class="list rectangle">
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit,  </li>
<li>Lorem ipsum dolor sit amet, </li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
</ul>
</div>
```
<p>Список с ромбами</p>
```html
<div class="template">
<ul class="list rhomb">
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit,  </li>
<li>Lorem ipsum dolor sit amet, </li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
</ul>
</div>
```
<p>Список с кругами</p>
```html
<div class="template">
<ul class="list circle">
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit,  </li>
<li>Lorem ipsum dolor sit amet, </li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
</ul>
</div>
```
<p>Список "Безникто"</p>
```html
<div class="template">
<ul class="list circle">
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit,  </li>
<li>Lorem ipsum dolor sit amet, </li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
</ul>
</div>
```
<p>Нумерованный список</p>
```html
<div class="template">
<ol class="list number-list">
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit,  </li>
<li>Lorem ipsum dolor sit amet, </li>
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</li>
</ol>
</div>
```
<p>Картинка и текст</p>
```html
<div class="template">
<div class="image path-4-1>
<img src="/grumpy.jpg" alt="" />
</div>
<p class="normal-txt path-4-3">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore </p>
</div>
```
<p>Текст и картинка</p>
```html
<div class="template">
<p class="normal-txt path-4-3">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore </p>
<div class="image path-4-1">
<img src="/grumpy.jpg" alt="" />
</div>
</div>
```
<p>Таблица</p>
```html
<div class="template">
<table class="content-table">
<tr>
<th>Lorem ipsum</th>
<th>Lorem ipsum</th>
<th>Lorem ipsum</th>
</tr>
<tr>
<td>Lorem ipsum</td>
<td>Lorem ipsum</td>
<td>Lorem ipsum</td>
</tr>
<tr>
<td>Lorem ipsum</td>
<td>Lorem ipsum</td>
<td>Lorem ipsum</td>
</tr>
</table>
</div>
```
<p>Ссылка после элемента</p>
```html
<a class="content-link" href="#">Lorem ipsum dolor sit amet</a>
```
<p>Кнопка после элемента</p>
```html
<a class="content-button" href="#">Lorem ipsum</a>
```
<p>Горизонтальная линия</p>
```html
<hr class="line">
```

## Классы

<dl>
<dt>$basic-dark</dt>
<dd>Переменная, определяющая основной цвет заголовков, линий и т.д.</dd>

<dt>$offset</dt>
<dd>Переменная, определяющая базовый боковой отступ элемента (по умолчанию 10px)</dd>

<dt>$margin</dt>
<dd>Переменная, определяющая базовый отступ сверху и снизу элемента (по умолчанию 20px)</dd>

<dt>$title</dt>
<dd>Переменная, определяющая базовый шрифт для заголовков и заголовков таблицы</dd>

<dt>.path-0 (depricated)</dt>
<dd>Блок во всю ширину родительского, с padding по бокам, равным $offset.</dd>

<dt>.marg-bottom</dt>
<dd>Отступ 0,5$margin (по умолчанию 10px)</dd>

<dt>.marg-b1</dt>
<dd>Отступ 1$margin (по умолчанию 20px)</dd>

<dt>.marg-b2</dt>
<dd>Отступ 2$margin (по умолчанию 40px)</dd>

<dt>.nomarg</dt>
<dd>Сброс margin у элемента</dd>

<dt>.padd-l</dt>
<dd>Padding слева, равный $offset, и сброс правого padding у элемента</dd>

<dt>.padd-r</dt>
<dd>Padding справа, равный $offset, и сброс левого padding у элемента</dd>

<dt>.nopadd</dt>
<dd>Сброс padding у элемента</dd>

<dt>.noindent</dt>
<dd>Сброс indent у элемента</dd>

<dt>.bord-b</dt>
<dd>Добавляет border ($basic-dark) и отступ ($margin) снизу элемента</dd>

<dt>.fl-l</dt>
<dd>Добавляет свойсво: "float:left" к элементу</dd>

<dt>.fl-r</dt>
<dd>Добавляет свойсво: "float:right" к элементу</dd>

<dt>.abs-t-l</dt>
<dd>Абсолютное позиционирование объекта с отступом от левого края ($offset) и отступом сверху ($margin)</dd>

<dt>.abs-t-r</dt>
<dd>Абсолютное позиционирование объекта с отступом от правого края ($offset) и отступом сверху ($margin)</dd>
</dl>

## Кастомные шаблоны
1. В директории проекта app/views/templates создать паршиал с версткой
<div class="unit clfl">

```html
<div class="unit-content">
  <div class="unit-image">
    <%= image_tag content[0].image.url(:thumb), class: "unit-img" %>
  </div>
  <span class="unit-title"><%= content[1].content_text %></span>
  <span class="unit-info"><%= content[2].content_text %></span>
  </div>

  <div class="unit-price">
  <span class="unit-price-title">Цена аренды</span>
  <span><%= content[3].content_text %></span>
  </div>

  <div class="unit-price">
  <span class="unit-price-title">Цена залога</span>
  <span><%= content[4].content_text %></span>
  </div>

</div>
```
2. Сделать запись с названием паршила в файле config/templates.yml
:template_type_render:
  :partial_name: Кастомный шпблон

3. В шаблонах админ.части сделать новый шаблон с выбранный паршилом и набором тегов как в паршиле.
