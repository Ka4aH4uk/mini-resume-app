# mini-resume-app
![Alt-текст](https://github.com/Ka4aH4uk/mini-resume-app/blob/master/So7Q-KefeKIPIYm1hLa5gdqfiFL9hpVjkjBQ7zFNyuoZ6MYmq17QJjTsOY2gc0e3t2AexI-tiTP1ICeMa1c3ninGvvwdM7NB5zecVDJkig4e77BZ9Ggju9BiXeMhSEQhIg=w3840.png?raw=true)
# Surf | Summer School 2023 | Study Jam | iOS

The application contains the functionality of a mini-resume, the “My Skills” block is editable, the rest is hardcode. The screen can scroll. Development should be carried out on UIKit without third-party libraries, only by native means.

### Общее

В приложении заложен функционал мини-резюме, блок “Мои навыки” - редактируемый, остальное - хардкод. Экран должен уметь скроллиться. 
Разработка должна вестись на UIKit без сторонних библиотек, только нативными средствами.

### Дизайн в Figma

https://www.figma.com/file/Xc7x55IXhOwVrTNpaydSzK/iOS-%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%7C-Resume%2C-Profile?type=design&node-id=1%3A141&mode=dev

### Состав экрана

1) Заголовок “Профиль”.
2) Фотография пользователя (хардкод).
3) Девиз пользователя, краткая информация. Лейбл ограничен двумя строчками, длинный текст обрезается троеточием. Значение - хардкод.
4) Место жительства пользователя. Ограничен одной строкой, длинный текст обрезается троеточием. Значение - хардкод.
5) Заголовок “Мои навыки” и кнопка режима редактирования. Иконка “карандашика” для входа в режим редактирования, иконка “галочки” для сохранения изменений. 
6) Блок мои навыки. Может редактироваться пользователем.
Ограничение высоты ячейки одной строкой. Максимальная ширина ячейки ограничена шириной экрана минус боковые отступы. Количество ячеек (навыков) в разделе не ограничено. Если текст не помещается, сокращать троеточием. 
В режиме редактирования на каждую ячейку с навыком добавляется крестик, по нажатию на который, навык удаляется. Также добавляется ячейка с плюсиком, по нажатию на которую, добавляется новый навык. Навык вводится через нативную Alert View. 
7) О себе. Текстовый блок. Количество строк не ограничено. Значение - хардкод.

<img src="https://github.com/Ka4aH4uk/mini-resume-app/blob/master/Simulator%20Screenshot%20-%20iPhone%2011%20-%202023-08-15%20at%2017.16.48.png?raw=true" width="200"> <img src="https://github.com/Ka4aH4uk/mini-resume-app/blob/master/Simulator%20Screenshot%20-%20iPhone%2011%20-%202023-08-15%20at%2017.17.01.png?raw=true" width="200"> <img src="https://github.com/Ka4aH4uk/mini-resume-app/blob/master/Simulator%20Screenshot%20-%20iPhone%2011%20-%202023-08-15%20at%2017.17.18.png?raw=true" width="200">
