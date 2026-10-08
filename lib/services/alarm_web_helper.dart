// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:async';

void playWebTingTung(bool isPlaying, Function() onLoop) {
  if (!isPlaying) return;
  
  js.context.callMethod('eval', ['''
    (function() {
      var ctx = new (window.AudioContext || window.webkitAudioContext)();
      function playNote(freq, start, duration) {
        var osc = ctx.createOscillator();
        var gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.type = 'sine';
        osc.frequency.setValueAtTime(freq, ctx.currentTime + start);
        gain.gain.setValueAtTime(0.8, ctx.currentTime + start);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + start + duration);
        osc.start(ctx.currentTime + start);
        osc.stop(ctx.currentTime + start + duration);
      }
      playNote(1200, 0, 0.4);   
      playNote(900, 0.45, 0.5); 
    })();
  ''']);

  Future.delayed(const Duration(milliseconds: 1500), onLoop);
}
