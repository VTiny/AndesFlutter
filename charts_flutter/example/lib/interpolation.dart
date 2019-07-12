class Interpolation {
  int n;
  List<num> xs;
  List<num> ys;

  bool spInitialized;
  List<num> spY2s;

  Interpolation(List<num> _xs, List<num> _ys) {
    this.n = _xs.length;
    this.xs = _xs;
    this.ys = _ys;
    this.spInitialized = false;
  }

  num spline(num x) {
    if (!this.spInitialized) {
      // Assume Natural Spline Interpolation
      num p, qn, sig, un;
      List<num> us;

      us = new List<num>(n - 1);
      spY2s = new List<num>(n);
      us[0] = spY2s[0] = 0.0;

      for (int i = 1; i <= n - 2; i++) {
        sig = (xs[i] - xs[i - 1]) / (xs[i + 1] - xs[i - 1]);
        p = sig * spY2s[i - 1] + 2.0;
        spY2s[i] = (sig - 1.0) / p;
        us[i] = (ys[i + 1] - ys[i]) / (xs[i + 1] - xs[i]) -
            (ys[i] - ys[i - 1]) / (xs[i] - xs[i - 1]);
        us[i] = (6.0 * us[i] / (xs[i + 1] - xs[i - 1]) - sig * us[i - 1]) / p;
      }
      qn = un = 0.0;

      spY2s[n - 1] = (un - qn * us[n - 2]) / (qn * spY2s[n - 2] + 1.0);
      for (int k = n - 2; k >= 0; k--) {
        spY2s[k] = spY2s[k] * spY2s[k + 1] + us[k];
      }

      this.spInitialized = true;
    }

    int klo, khi, k;
    num h, b, a;

    klo = 0;
    khi = n - 1;
    while (khi - klo > 1) {
      k = (khi + klo) >> 1;
      if (xs[k] > x)
        khi = k;
      else
        klo = k;
    }
    h = xs[khi] - xs[klo];
    if (h == 0.0) {
      throw new Exception('h==0.0');
    }
    a = (xs[khi] - x) / h;
    b = (x - xs[klo]) / h;
    return a * ys[klo] +
        b * ys[khi] +
        ((a * a * a - a) * spY2s[klo] + (b * b * b - b) * spY2s[khi]) *
            (h * h) /
            6.0;
  }
}
