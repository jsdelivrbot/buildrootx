From 71924291b586feaa7045fe0ad7874116e3d1de80 Mon Sep 17 00:00:00 2001
From: Mike Gilbert <floppym@gentoo.org>
Date: Wed, 25 Apr 2018 13:22:49 -0400
Subject: [PATCH] Disable various compiler configs

---
 build/config/compiler/BUILD.gn | 61 ++++++++++------------------------
 1 file changed, 18 insertions(+), 43 deletions(-)

diff --git a/build/config/compiler/BUILD.gn b/build/config/compiler/BUILD.gn
index 461e62da2d50..964d41e9c971 100644
--- a/build/config/compiler/BUILD.gn
+++ b/build/config/compiler/BUILD.gn
@@ -222,8 +222,6 @@ config("compiler") {
 
   configs += [
     # See the definitions below.
-    ":clang_revision",
-    ":compiler_cpu_abi",
     ":compiler_codegen",
   ]
 
@@ -464,18 +462,6 @@ config("compiler") {
     cflags += [ "-fcolor-diagnostics" ]
   }
 
-  # TODO(hans): Remove this once Clang generates better optimized debug info by
-  # default. https://crbug.com/765793
-  if (is_clang && !is_nacl && current_toolchain == host_toolchain &&
-      target_os != "chromeos") {
-    cflags += [
-      "-Xclang",
-      "-mllvm",
-      "-Xclang",
-      "-instcombine-lower-dbg-declare=0",
-    ]
-  }
-
   # Print absolute paths in diagnostics. There is no precedent for doing this
   # on Linux/Mac (GCC doesn't support it), but MSVC does this with /FC and
   # Windows developers rely on it (crbug.com/636109) so only do this on Windows.
@@ -1387,10 +1373,6 @@ config("default_warnings") {
 
         # TODO(hans): https://crbug.com/766891
         "-Wno-null-pointer-arithmetic",
-
-        # Ignore warnings about MSVC optimization pragmas.
-        # TODO(thakis): Only for no_chromium_code? http://crbug.com/505314
-        "-Wno-ignored-pragma-optimize",
       ]
       if (llvm_force_head_revision) {
         cflags += [
@@ -1440,22 +1422,6 @@ config("chromium_code") {
       "__STDC_FORMAT_MACROS",
     ]
 
-    if (!is_debug && !using_sanitizer &&
-        (!is_linux || !is_clang || is_official_build) &&
-        current_cpu != "s390x" && current_cpu != "s390" &&
-        current_cpu != "ppc64" && current_cpu != "ppc64" &&
-        current_cpu != "mips" && current_cpu != "mips64") {
-      # _FORTIFY_SOURCE isn't really supported by Clang now, see
-      # http://llvm.org/bugs/show_bug.cgi?id=16821.
-      # It seems to work fine with Ubuntu 12 headers though, so use it in
-      # official builds.
-      #
-      # Non-chromium code is not guaranteed to compile cleanly with
-      # _FORTIFY_SOURCE. Also, fortified build may fail when optimizations are
-      # disabled, so only do that for Release build.
-      defines += [ "_FORTIFY_SOURCE=2" ]
-    }
-
     if (is_mac || is_ios) {
       cflags_objc = [ "-Wobjc-missing-property-synthesis" ]
       cflags_objcc = [ "-Wobjc-missing-property-synthesis" ]
@@ -1786,7 +1752,8 @@ config("default_stack_frames") {
 }
 
 # Default "optimization on" config.
-config("optimize") {
+config("optimize") { }
+config("xoptimize") {
   if (is_win) {
     # TODO(thakis): Remove is_clang here, https://crbug.com/598772
     if (is_official_build && full_wpo_on_official && !is_clang) {
@@ -1820,7 +1787,8 @@ config("optimize") {
 }
 
 # Same config as 'optimize' but without the WPO flag.
-config("optimize_no_wpo") {
+config("optimize_no_wpo") { }
+config("xoptimize_no_wpo") {
   if (is_win) {
     # Favor size over speed, /O1 must be before the common flags. The GYP
     # build also specifies /Os and /GF but these are implied by /O1.
@@ -1843,7 +1811,8 @@ config("optimize_no_wpo") {
 }
 
 # Turn off optimizations.
-config("no_optimize") {
+config("no_optimize") { }
+config("xno_optimize") {
   if (is_win) {
     cflags = [
       "/Od",  # Disable optimization.
@@ -1867,7 +1836,8 @@ config("no_optimize") {
 # Turns up the optimization level. On Windows, this implies whole program
 # optimization and link-time code generation which is very expensive and should
 # be used sparingly.
-config("optimize_max") {
+config("optimize_max") { }
+config("xoptimize_max") {
   if (is_nacl && is_nacl_irt) {
     # The NaCl IRT is a special case and always wants its own config.
     # Various components do:
@@ -1914,7 +1884,8 @@ config("optimize_max") {
 #
 # TODO(crbug.com/621335) - rework how all of these configs are related
 # so that we don't need this disclaimer.
-config("optimize_speed") {
+config("optimize_speed") { }
+config("xoptimize_speed") {
   if (is_nacl && is_nacl_irt) {
     # The NaCl IRT is a special case and always wants its own config.
     # Various components do:
@@ -1952,7 +1923,8 @@ config("optimize_speed") {
   }
 }
 
-config("optimize_fuzzing") {
+config("optimize_fuzzing") { }
+config("xoptimize_fuzzing") {
   cflags = [ "-O1" ] + common_optimize_on_cflags
   ldflags = common_optimize_on_ldflags
   visibility = [ ":default_optimization" ]
@@ -2034,7 +2006,8 @@ config("afdo") {
 #   configs += [ "//build/config/compiler:symbols" ]
 
 # Full symbols.
-config("symbols") {
+config("symbols") { }
+config("xsymbols") {
   if (is_win) {
     if (use_goma || is_clang) {
       # Note that with VC++ this requires is_win_fastlink, enforced elsewhere.
@@ -2126,7 +2099,8 @@ config("symbols") {
 # Minimal symbols.
 # This config guarantees to hold symbol for stack trace which are shown to user
 # when crash happens in unittests running on buildbot.
-config("minimal_symbols") {
+config("minimal_symbols") { }
+config("xminimal_symbols") {
   if (is_win) {
     # Linker symbols for backtraces only.
     cflags = []
@@ -2157,7 +2131,8 @@ config("minimal_symbols") {
 }
 
 # No symbols.
-config("no_symbols") {
+config("no_symbols") { }
+config("xno_symbols") {
   if (!is_win) {
     cflags = [ "-g0" ]
     asmflags = cflags
-- 
2.17.0

