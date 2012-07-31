xss
===

## 1. Selectors
### 1.1 Indentation
```css
body
  background: #ccc
  .navbar
    position: fixed
    top: 0
```
Compile to:
```css
body {
  background: #ccc;
}
body .navbar {
  position: fixed;
  top: 0;
}
```
### 1.2 Rule Sets
```css
.foo, .bar
  color: grey
```
Compile to:
```css
.foo,
.bar {
  color: grey;
}
```