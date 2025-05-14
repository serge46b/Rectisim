# Как собрать код

В проекте код разбит на несколько секций, каждая секция принадлежит своей ячейки памяти и компилируется отдельно. Ниже будет приведён список зависимотсей каждого файла.

Чтобы скомпилировать программу потребуется сохранить каждый файл кода как объектный, используя CocoIDE, а потом, используя CocoLinker собрать файлы в образы в соответствии со структурой ниже.

## структура

Нумерация всех ячеек идёт сверху вниз

0. main page.asm (Использует: master page ctrl.asm)
1. game_init.asm (Использует: stdio.asm; slave page ctrl.asm)
2. game_logic.asm (Использует: stdio.asm; slave page ctrl.asm; master page ctrl.asm; task SP manip.asm)
3. emp.asm (Использует: stdio.asm; slave page ctrl.asm)
4. task_assigning.asm (Использует: stdio.asm; slave page ctrl.asm; master page ctrl.asm; task SP manip.asm)
5. task_placement.asm (Использует: stdio.asm; slave page ctrl.asm; task SP manip.asm)
6. task_checking.asm (Использует: stdio.asm; slave page ctrl.asm; master page ctrl.asm; task SP manip.asm)
7. cell upgrade.asm (Использует: stdio.asm; slave page ctrl.asm)
