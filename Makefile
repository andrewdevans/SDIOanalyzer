SRCS := $(wildcard *.cpp)
DEPDIR := .deps
DEPFILES := $(patsubst %.cpp,$(DEPDIR)/%.d,$(SRCS))
OBJS := $(patsubst %.cpp,%.o,$(SRCS))
LIB := libSDIOanalyzer.so

ANALYZER_SDK := ../logic-sdk
ANALYZER_SDK_INCLUDE := $(ANALYZER_SDK)/include
ANALYZER_SDK_LIB := $(ANALYZER_SDK)/lib

CPPFLAGS = -I$(ANALYZER_SDK_INCLUDE) -MT $@ -MD -MP -MF $(DEPDIR)/$*.d
CXXFLAGS := -fPIC -W -Wall -Werror
LDFLAGS := -shared
LDLIBS := $(ANALYZER_SDK_LIB)/Analyzer64.lib

.PHONY: all
all: $(LIB)

$(LIB): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@

%.o: %.cpp $(DEPDIR)/%.d | $(DEPDIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<

$(DEPDIR):
	mkdir -p $@

$(DEPFILES):
include $(wildcard $(DEPFILES))

.PHONY: clean
clean:
	rm -rf $(DEPDIR) $(OBJS) $(LIB)
